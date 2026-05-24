import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_model.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ScheduleModel>> getJadwal(String userId) {
    return _firestore
        .collection('schedules')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ScheduleModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort di sisi client sementara index belum siap
      list.sort((a, b) =>
          a.scheduledDate.compareTo(b.scheduledDate));
      return list;
    });
  }

  Future<String?> tambahJadwal(ScheduleModel jadwal) async {
    try {
      await _firestore.collection('schedules').add(jadwal.toMap());
      return null;
    } catch (e) {
      return 'Gagal menambah jadwal: $e';
    }
  }

  Future<String?> updateStatus(String scheduleId, String status) async {
    try {
      await _firestore
          .collection('schedules')
          .doc(scheduleId)
          .update({'status': status});
      return null;
    } catch (e) {
      return 'Gagal update status: $e';
    }
  }

  Future<String?> hapusJadwal(String scheduleId) async {
    try {
      await _firestore.collection('schedules').doc(scheduleId).delete();
      return null;
    } catch (e) {
      return 'Gagal menghapus jadwal: $e';
    }
  }

  // Ambil jadwal terdekat (belum selesai, diurutkan dari yang paling dekat)
  Stream<List<ScheduleModel>> getJadwalTerdekat(
      String userId, {int limit = 3}) {
    return _firestore
        .collection('schedules')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'planned')
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ScheduleModel.fromMap(doc.data(), doc.id))
          .toList();

      // Urutkan dari yang paling dekat waktunya
      final now = DateTime.now();
      list.sort((a, b) {
        // Hitung selisih waktu dari sekarang
        final selisihA = a.scheduledDate.difference(now).abs();
        final selisihB = b.scheduledDate.difference(now).abs();
        return selisihA.compareTo(selisihB);
      });

      // Ambil hanya sejumlah limit
      return list.take(limit).toList();
    });
  }
}