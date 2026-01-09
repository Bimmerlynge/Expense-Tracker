import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData mainTheme = ThemeData(
    iconTheme: IconThemeData(color: AppColors.onPrimary),
    bottomAppBarTheme: BottomAppBarThemeData(
      shape: CircularNotchedRectangle(),
      color: AppColors.primary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: CircleBorder(),
      foregroundColor: AppColors.primarySecondText,
      backgroundColor: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.primary,
    appBarTheme: AppBarTheme(
      color: AppColors.primary,
      titleTextStyle: TextStyle(
        color: AppColors.primaryText,
        fontSize: 24,
        letterSpacing: 2,
      ),
      iconTheme: IconThemeData(color: AppColors.onPrimary),
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      selectedIconTheme: IconThemeData(color: AppColors.onPrimary),
      unselectedIconTheme: IconThemeData(
        color: AppColors.onPrimary.withAlpha(100),
      ),
      selectedItemColor: AppColors.onPrimary,
      unselectedItemColor: AppColors.onPrimary.withAlpha(100),
    ),
    iconButtonTheme: IconButtonThemeData(),
    primaryTextTheme: TTextTheme.mainTheme,
    snackBarTheme: SnackBarThemeData(),
    dialogTheme: DialogThemeData(
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(color: AppColors.onPrimary),
      ),
      backgroundColor: AppColors.primary,
      titleTextStyle: TTextTheme.mainTheme.titleLarge,
      contentTextStyle: TTextTheme.mainTheme.bodySmall,
      alignment: Alignment.centerLeft,
      iconColor: AppColors.onPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      labelStyle: TTextTheme.mainTheme.labelSmall,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
    ),
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
    tabBarTheme: TabBarThemeData(
      dividerColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(color: AppColors.onPrimary),
      indicatorColor: AppColors.onPrimary,
      unselectedLabelColor: AppColors.onPrimary.withAlpha(100),
    ),
    chipTheme: ChipThemeData(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (!states.contains(WidgetState.selected)) {
          return AppColors.primarySecondText;
        }
        return AppColors.primaryText;
      }),
    ),
    canvasColor: AppColors.primary,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.primary),
    checkboxTheme: CheckboxThemeData(
      side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
        return const BorderSide(color: AppColors.primaryText, width: 2);
      }),
    ),
  );
}
