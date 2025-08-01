import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static final ThemeData mainTheme = ThemeData(
    iconTheme: IconThemeData(
      color: AppColors.onPrimary,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      shape: CircularNotchedRectangle(),
      color: AppColors.primary
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: CircleBorder(),
      foregroundColor: AppColors.onPrimary,
      backgroundColor: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.secondary,
    appBarTheme: AppBarTheme(
      color: AppColors.primary,

    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      selectedIconTheme: IconThemeData(color: AppColors.onPrimary),
      unselectedIconTheme: IconThemeData(color: AppColors.onPrimary.withAlpha(100)),
      selectedItemColor: AppColors.onPrimary, // Optional: for label color
      unselectedItemColor: AppColors.onPrimary.withAlpha(100),
    ),
    iconButtonTheme: IconButtonThemeData(

    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.red)
    )
  );
}