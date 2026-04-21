import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LabelledField extends StatelessWidget {
  final String label;
  final Widget child;

  const LabelledField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          color: AppColors.primarySecondText,
          fontSize: 14,
        )),
        SizedBox(height: 6),
        child
      ],
    );
  }
}
