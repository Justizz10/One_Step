import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  // Simpan sesi latihan selesai
  Future<void> simpanSesi({
    required String activityName,
    required int duration,
    required double caloriesBurned,
  }) async {
    if (userId.isEmpty) return;
    await _firestore.collection('progress').add({
      'userId': userId,
      'activityName': activityName,
      'completedAt': FieldValue.serverTimestamp(), // ← pakai serverTimestamp
      'duration': duration,
      'caloriesBurned': caloriesBurned,
    });
  }

  // Ambil semua riwayat
  Stream<List<Map<String, dynamic>>> getRiwayat() {
    if (userId.isEmpty) return Stream.value([]);
    return _firestore
        .collection('progress')
        .where('userId', isEqualTo: userId)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList());
  }

  // Statistik mingguan
  Future<Map<String, dynamic>> getStatistikMingguan() async {
    if (userId.isEmpty) {
      return {'totalSesi': 0, 'totalMenit': 0, 'totalKalori': 0};
    }

    try {
      // Ambil semua progress milik user tanpa filter tanggal dulu
      final snap = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .get();

      // Filter minggu ini di sisi client
      final now = DateTime.now();
      final awalMinggu = DateTime(
        now.year, now.month,
        now.day - (now.weekday - 1), // Senin minggu ini
      );

      final docsMingguan = snap.docs.where((doc) {
        final data = doc.data();
        DateTime? tanggal;

        // Handle berbagai format tanggal
        if (data['completedAt'] is Timestamp) {
          tanggal = (data['completedAt'] as Timestamp).toDate();
        } else if (data['completedAt'] is DateTime) {
          tanggal = data['completedAt'] as DateTime;
        }

        if (tanggal == null) return false;
        return tanggal.isAfter(awalMinggu) ||
            tanggal.isAtSameMomentAs(awalMinggu);
      }).toList();

      int totalSesi = docsMingguan.length;
      int totalMenit = docsMingguan.fold(0,
              (s, d) => s + ((d.data()['duration'] as num?)?.toInt() ?? 0));
      double totalKalori = docsMingguan.fold(0.0,
              (s, d) => s + ((d.data()['caloriesBurned'] as num?)?.toDouble() ?? 0));

      return {
        'totalSesi': totalSesi,
        'totalMenit': totalMenit,
        'totalKalori': totalKalori.toInt(),
      };
    } catch (e) {
      return {'totalSesi': 0, 'totalMenit': 0, 'totalKalori': 0};
    }
  }

  // Statistik hari ini (untuk beranda)
  Future<Map<String, dynamic>> getStatistikHariIni() async {
    if (userId.isEmpty) {
      return {'totalSesi': 0, 'totalKalori': 0};
    }

    try {
      final now = DateTime.now();
      final awalHari = DateTime(now.year, now.month, now.day);

      final snap = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .get();

      final docsHariIni = snap.docs.where((doc) {
        final data = doc.data();
        DateTime? tanggal;
        if (data['completedAt'] is Timestamp) {
          tanggal = (data['completedAt'] as Timestamp).toDate();
        }
        if (tanggal == null) return false;
        return tanggal.isAfter(awalHari) ||
            tanggal.isAtSameMomentAs(awalHari);
      }).toList();

      double totalKalori = docsHariIni.fold(0.0,
              (s, d) => s +
              ((d.data()['caloriesBurned'] as num?)?.toDouble() ?? 0));

      return {
        'totalSesi': docsHariIni.length,
        'totalKalori': totalKalori.toInt(),
      };
    } catch (e) {
      return {'totalSesi': 0, 'totalKalori': 0};
    }
  }
  // ─── STREAK ─────────────────────────────────────────

  int _getNomorMinggu(DateTime date) {
    final awalTahun = DateTime(date.year, 1, 1);
    final selisihHari = date.difference(awalTahun).inDays;
    return (selisihHari / 7).ceil();
  }

  Future<int> getSesiMinggu(DateTime tanggalDiMinggu) async {
    if (userId.isEmpty) return 0;
    try {
      final awalMinggu = tanggalDiMinggu.subtract(
        Duration(days: tanggalDiMinggu.weekday - 1),
      );
      final mulai = DateTime(
          awalMinggu.year, awalMinggu.month, awalMinggu.day);
      final akhir = mulai.add(const Duration(days: 7));

      final snap = await _firestore
          .collection('progress')
          .where('userId', isEqualTo: userId)
          .get();

      return snap.docs.where((doc) {
        final data = doc.data();
        if (data['completedAt'] is! Timestamp) return false;
        final tgl =
        (data['completedAt'] as Timestamp).toDate();
        return tgl.isAfter(mulai) && tgl.isBefore(akhir);
      }).length;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, dynamic>> getDataStreak() async {
    if (userId.isEmpty) {
      return {'streak': 0, 'nomorMingguTerakhir': 0};
    }
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      final data = doc.data();
      return {
        'streak': data?['streak'] ?? 0,
        'nomorMingguTerakhir':
        data?['nomorMingguTerakhir'] ?? 0,
      };
    } catch (e) {
      return {'streak': 0, 'nomorMingguTerakhir': 0};
    }
  }

  Future<int> evaluasiStreak() async {
    if (userId.isEmpty) return 0;
    try {
      final sekarang = DateTime.now();
      final nomorMingguSekarang =
      _getNomorMinggu(sekarang);

      final dataStreak = await getDataStreak();
      int streakSekarang = dataStreak['streak'] as int;
      int nomorMingguTerakhir =
      dataStreak['nomorMingguTerakhir'] as int;

      final sesiMingguIni =
      await getSesiMinggu(sekarang);

      // Masih di minggu yang sama
      if (nomorMingguTerakhir == nomorMingguSekarang) {
        if (sesiMingguIni >= 7 && streakSekarang == 0) {
          streakSekarang = 1;
          await _simpanStreak(
              streakSekarang, nomorMingguSekarang);
        }
        return streakSekarang;
      }

      // Minggu baru — evaluasi minggu lalu
      final mingguLalu =
      sekarang.subtract(const Duration(days: 7));
      final sesiMingguLalu =
      await getSesiMinggu(mingguLalu);

      if (sesiMingguLalu >= 7) {
        streakSekarang = streakSekarang + 1;
      } else if (nomorMingguTerakhir > 0) {
        streakSekarang = 0;
      }

      if (sesiMingguIni >= 7) {
        streakSekarang = streakSekarang + 1;
      }

      await _simpanStreak(
          streakSekarang, nomorMingguSekarang);
      return streakSekarang;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _simpanStreak(
      int streak, int nomorMinggu) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .set(
      {
        'streak': streak,
        'nomorMingguTerakhir': nomorMinggu,
        'streakUpdatedAt':
        FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}