import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

Container inputContainer(Widget child) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
      border: BoxBorder.fromBorderSide(
        BorderSide(color: AppColors.primarySecondText),
      ),
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(45),
    ),
    child: child,
  );
}