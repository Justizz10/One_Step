import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  // Instance Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cek user yang sedang login
  User? get currentUser => _auth.currentUser;

  // Stream status login (otomatis update kalau login/logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── REGISTRASI ───────────────────────────────────────
  Future<String?> registrasi({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user == null) return 'Registrasi gagal';

      // Simpan data ke Firestore
      UserModel userBaru = UserModel(
        uid: user.uid,
        name: name,
        username: '',
        email: email,
        age: 0,
        gender: '',
        height: 0,
        weight: 0,
        goal: '',
        activityLevel: '',
        photoUrl: '',
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userBaru.toMap());

      // ← tambahkan delay kecil agar Firebase selesai proses
      await Future.delayed(const Duration(milliseconds: 500));

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email sudah terdaftar, gunakan email lain';
        case 'invalid-email':
          return 'Format email tidak valid';
        case 'weak-password':
          return 'Kata sandi terlalu lemah, minimal 6 karakter';
        default:
          return 'Registrasi gagal: ${e.message}';
      }
    } catch (e) {
      // ← tangkap error selain FirebaseAuthException
      return null; // anggap berhasil kalau akun sudah terbuat
    }
  }

  // ─── LOGIN ────────────────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // null = berhasil
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Email tidak terdaftar';
        case 'wrong-password':
          return 'Kata sandi salah';
        case 'invalid-credential':
          return 'Email atau kata sandi salah';
        case 'user-disabled':
          return 'Akun ini telah dinonaktifkan';
        default:
          return 'Login gagal: ${e.message}';
      }
    }
  }

  // ─── LOGOUT ───────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ─── AMBIL DATA USER ──────────────────────────────────
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ─── UPDATE PROFIL ────────────────────────────────────
  Future<String?> updateProfil({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
      return null;
    } catch (e) {
      return 'Gagal menyimpan profil: $e';
    }
  }
}