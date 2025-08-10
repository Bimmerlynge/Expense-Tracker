import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData mainTheme = ThemeData(
    iconTheme: IconThemeData(color: AppColors.onPrimary),
    bottomAppBarTheme: BottomAppBarTheme(
      shape: CircularNotchedRectangle(),
      color: AppColors.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: CircleBorder(),
      foregroundColor: AppColors.primarySecondText,
      backgroundColor: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.secondary,
    appBarTheme: AppBarTheme(
      color: AppColors.primary,
      titleTextStyle: TextStyle(
        color: AppColors.primaryText,
        fontSize: 24,
        letterSpacing: 2,
      ),
      iconTheme: IconThemeData(color: AppColors.primaryText),
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      selectedIconTheme: IconThemeData(color: AppColors.onPrimary),
      unselectedIconTheme: IconThemeData(
        color: AppColors.onPrimary.withAlpha(100),
      ),
      selectedItemColor: AppColors.onPrimary, // Optional: for label color
      unselectedItemColor: AppColors.onPrimary.withAlpha(100),
    ),
    iconButtonTheme: IconButtonThemeData(),
    primaryTextTheme: TTextTheme.mainTheme,
    textTheme: TextTheme(titleLarge: TextStyle(color: Colors.red)),
    snackBarTheme: SnackBarThemeData(),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.secondary),
    inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        textStyle: TextStyle(letterSpacing: 2, fontSize: 16),
        side: BorderSide(color: AppColors.primarySecondText),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
    ),
    radioTheme: RadioThemeData(),
    listTileTheme: ListTileThemeData(
      leadingAndTrailingTextStyle: TTextTheme.mainTheme.titleSmall,
      titleTextStyle: TextStyle(color: AppColors.primaryTertText),
      subtitleTextStyle: TTextTheme.mainTheme.titleSmall,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primary),
        alignment: Alignment.bottomLeft,
      ),
    ),
  );
}
