import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RadioButton<T> extends StatelessWidget {
  final T value;
  final T selectedValue;
  final Widget child;
  final void Function(T value) onSelected;

  const RadioButton({super.key, required this.value, required this.child, required this.onSelected, required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return OutlinedButton(
      onPressed: () => onSelected(value),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? AppColors.onPrimary : AppColors.primarySecondText
        ),
        foregroundColor: isSelected ? AppColors.onPrimary : AppColors.primarySecondText
      ),
      child: child,
    );
  }
}
