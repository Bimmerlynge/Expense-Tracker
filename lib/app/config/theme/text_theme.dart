import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TTextTheme {
  static final TextTheme mainTheme = TextTheme(
    bodyMedium: TextStyle(color: AppColors.primaryText),
    bodySmall: TextStyle(color: AppColors.primaryText),
    // headlineLarge:
    headlineMedium: TextStyle(),
    titleSmall: TextStyle(fontSize: 12, color: AppColors.primaryText),
    titleMedium: TextStyle(fontSize: 16, color: AppColors.primaryText),
    titleLarge: TextStyle(fontSize: 24, color: AppColors.primaryText),
    labelSmall: TextStyle(fontSize: 12, color: AppColors.primaryText, letterSpacing: 2),
    labelMedium: TextStyle(fontSize: 16, color: AppColors.primaryText, letterSpacing: 2),
    labelLarge: TextStyle(fontSize: 20, color: AppColors.primaryText, letterSpacing: 2)
  );
}
