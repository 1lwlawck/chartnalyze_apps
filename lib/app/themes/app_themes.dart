import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    fontFamily: AppFonts.nextTrial,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primaryGreen,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}
