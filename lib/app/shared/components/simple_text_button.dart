import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SimpleTextButton extends StatelessWidget {
  final VoidCallback onPress;
  final Color color;
  final IconData? iconData;
  final Color backgroundColor;
  final String labelText;
  final FontWeight fontWeight;

  SimpleTextButton({
    super.key,
    required this.onPress,
    this.iconData,
    Color? color,
    this.backgroundColor = Colors.transparent,
    required this.labelText,
    this.fontWeight = FontWeight.bold,
  }) : color = color ?? AppColors.onPrimary;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPress,
      icon: iconData != null ? Icon(iconData, color: color) : null,
      label: Text(
        labelText,
        style: TextStyle(color: color, fontWeight: fontWeight),
      ),
      style: TextButton.styleFrom(backgroundColor: backgroundColor),
    );
  }
}
