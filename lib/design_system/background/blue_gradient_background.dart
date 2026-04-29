import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BlueLinearGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;

  const BlueLinearGradient({
    super.key,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: begin,
          end: end,
        ),
      ),
    );
  }
}