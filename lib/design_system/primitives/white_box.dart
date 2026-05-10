import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WhiteBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const WhiteBox({
    super.key,
    required this.child,
    this. borderRadius = 10
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: AppColors.whiter,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}