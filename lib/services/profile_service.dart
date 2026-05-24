import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  // READ — Ambil data profil sekali
  Future<UserModel?> getProfil() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // READ — Stream profil real-time
  Stream<UserModel?> getProfilStream() {
    if (userId.isEmpty) return Stream.value(null);
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // UPDATE — Update data profil teks
  Future<String?> updateProfil({
    required String name,
    required String username,
    required String gender,
    required int age,
    required double height,
    required double weight,
    required String goal,
    required String activityLevel,
  }) async {
    try {
      // Pakai set + merge agar bisa create sekaligus update
      await _firestore.collection('users').doc(userId).set(
        {
          'uid': userId,
          'name': name,
          'username': username,
          'gender': gender,
          'age': age,
          'height': height,
          'weight': weight,
          'goal': goal,
          'activityLevel': activityLevel,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true), // ← tidak overwrite field lain
      );
      return null;
    } catch (e) {
      return 'Gagal update profil: $e';
    }
  }

  // UPDATE — Simpan foto sebagai Base64
  Future<String?> updateFotoProfil(File foto) async {
    try {
      final bytes = await foto.readAsBytes();

      if (bytes.lengthInBytes > 700000) {
        return 'Foto terlalu besar! Pilih foto di bawah 700KB.';
      }

      final base64String = base64Encode(bytes);
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      // Pakai set + merge
      await _firestore.collection('users').doc(userId).set(
        {
          'uid': userId,
          'photoUrl': dataUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return null;
    } catch (e) {
      return 'Gagal simpan foto: $e';
    }
  }

  // DELETE — Hapus foto profil
  Future<String?> hapusFotoProfil() async {
    try {
      await _firestore.collection('users').doc(userId).set(
        {
          'uid': userId,
          'photoUrl': '',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return null;
    } catch (e) {
      return 'Gagal hapus foto: $e';
    }
  }

  // DELETE — Hapus akun permanen
  Future<String?> hapusAkun() async {
    try {
      // Hapus data Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .delete();

      // Hapus akun Firebase Auth
      await _auth.currentUser?.delete();

      return null;
    } catch (e) {
      return 'Gagal hapus akun: $e';
    }
  }
}