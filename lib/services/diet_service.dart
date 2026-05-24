import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diet_model.dart';

class DietService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hitung kebutuhan kalori harian (TDEE)
  double hitungKaloriHarian({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  }) {
    // Hitung BMR dengan rumus Mifflin-St Jeor
    double bmr;
    if (gender == 'M') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Faktor aktivitas
    double faktor;
    switch (activityLevel) {
      case 'light': faktor = 1.375; break;
      case 'moderate': faktor = 1.55; break;
      case 'active': faktor = 1.725; break;
      default: faktor = 1.2; // sedentary
    }

    double tdee = bmr * faktor;

    // Sesuaikan dengan tujuan
    switch (goal) {
      case 'lose_weight': return tdee - 500;
      case 'maintain': return tdee;
      default: return tdee;
    }
  }

  Stream<List<FoodLogModel>> getFoodLogHariIni(String userId) {
    final sekarang = DateTime.now();
    final awalHari = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final akhirHari = awalHari.add(const Duration(days: 1));

    return _firestore
        .collection('foodLogs')
        .where('userId', isEqualTo: userId)
        .where('logDate', isGreaterThanOrEqualTo: awalHari)
        .where('logDate', isLessThan: akhirHari)
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map((doc) => FoodLogModel.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => a.logDate.compareTo(b.logDate));
      return list;
    });
  }

  // Tambah food log
  Future<String?> tambahFoodLog(FoodLogModel log) async {
    try {
      await _firestore.collection('foodLogs').add(log.toMap());
      return null;
    } catch (e) {
      return 'Gagal menyimpan: $e';
    }
  }

  // Hapus food log
  Future<void> hapusFoodLog(String logId) async {
    await _firestore.collection('foodLogs').doc(logId).delete();
  }
}