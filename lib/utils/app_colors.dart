import 'package:flutter/material.dart';

class AppColors {
  // Warna utama
  static const Color primary     = Color(0xFF1A3A5C);
  static const Color primaryLight = Color(0xFF2E75B6);
  static const Color accent      = Color(0xFF1F7A8C);

  // Background
  static const Color background  = Color(0xFFF0F7FF);
  static const Color cardBg      = Color(0xFFFFFFFF);
  static const Color blueBg      = Color(0xFFDEEAF1);

  // Teks
  static const Color textDark    = Color(0xFF2F2F2F);
  static const Color textGrey    = Color(0xFF888888);
  static const Color textWhite   = Color(0xFFFFFFFF);

  // Status
  static const Color success     = Color(0xFF2E7D32);
  static const Color warning     = Color(0xFFF9A825);
  static const Color danger      = Color(0xFFC62828);

  // Gradient beranda
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}