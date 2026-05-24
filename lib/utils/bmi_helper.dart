import 'package:flutter/material.dart';

class BMIHelper {
  // Hitung nilai BMI
  static double hitungBMI(double beratKg, double tinggiCm) {
    if (beratKg <= 0 || tinggiCm <= 0) return 0;
    final tinggiM = tinggiCm / 100;
    return beratKg / (tinggiM * tinggiM);
  }

  // Kategori BMI standar WHO
  static String getKategori(double bmi) {
    if (bmi <= 0) return 'Belum diset';
    if (bmi < 18.5) return 'Berat Badan Kurang';
    if (bmi < 25.0) return 'Berat Badan Normal';
    if (bmi < 30.0) return 'Berat Badan Berlebih';
    return 'Obesitas';
  }

  // Warna berdasarkan kategori
  static Color getWarna(double bmi) {
    if (bmi <= 0) return const Color(0xFF888888);
    if (bmi < 18.5) return const Color(0xFF2196F3); // Biru
    if (bmi < 25.0) return const Color(0xFF2E7D32); // Hijau
    if (bmi < 30.0) return const Color(0xFFF9A825); // Kuning
    return const Color(0xFFC62828);                 // Merah
  }

  // Ikon berdasarkan kategori
  static IconData getIkon(double bmi) {
    if (bmi <= 0) return Icons.help_outline;
    if (bmi < 18.5) return Icons.trending_down;
    if (bmi < 25.0) return Icons.check_circle;
    if (bmi < 30.0) return Icons.warning_amber;
    return Icons.dangerous_outlined;
  }

  // Saran singkat berdasarkan kategori
  static String getSaran(double bmi) {
    if (bmi <= 0) return 'Lengkapi profil untuk melihat BMI';
    if (bmi < 18.5) {
      return 'Tingkatkan asupan kalori & protein untuk '
          'mencapai berat badan ideal';
    }
    if (bmi < 25.0) {
      return 'Pertahankan pola makan sehat & olahraga '
          'rutin untuk menjaga BMI ideal';
    }
    if (bmi < 30.0) {
      return 'Kurangi asupan kalori & tingkatkan '
          'aktivitas fisik secara bertahap';
    }
    return 'Konsultasikan dengan dokter & mulai program '
        'diet & olahraga terstruktur';
  }

  // Berat badan ideal berdasarkan tinggi (rumus Devine)
  static String getBBIdeal(double tinggiCm, String gender) {
    if (tinggiCm <= 0) return '-';
    double bbIdeal;
    if (gender == 'M') {
      bbIdeal = 50 + 2.3 * ((tinggiCm - 152.4) / 2.54);
    } else {
      bbIdeal = 45.5 + 2.3 * ((tinggiCm - 152.4) / 2.54);
    }
    if (bbIdeal <= 0) return '-';
    final min = (bbIdeal - 3).toStringAsFixed(1);
    final max = (bbIdeal + 3).toStringAsFixed(1);
    return '$min - $max kg';
  }

  // Persentase untuk progress indicator (range 10-40)
  static double getProgress(double bmi) {
    if (bmi <= 0) return 0;
    // Clamp antara 10 dan 40
    final clamped = bmi.clamp(10.0, 40.0);
    return (clamped - 10) / 30; // 0.0 - 1.0
  }
}