import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GrayBox extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignment;
  final double? width;
  final double? height;

  const GrayBox({super.key, required this.child, required this.alignment, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(6),
      alignment: alignment,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}