import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TTextTheme {
  static final TextTheme mainTheme = TextTheme(
    bodyMedium: TextStyle(color: AppColors.primarySecondText),
    bodySmall: TextStyle(color: AppColors.primarySecondText),
    // headlineLarge:
    headlineMedium: TextStyle(),
    titleSmall: TextStyle(fontSize: 12, color: AppColors.primaryText),
    labelSmall: TextStyle(fontSize: 14, color: AppColors.onPrimary, letterSpacing: 2),
    labelMedium: TextStyle(fontSize: 16, color: AppColors.primaryText, letterSpacing: 2)
  );
}
