import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24, fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 14, color: AppColors.textDark, height: 1.5,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, color: AppColors.textGrey,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
}