import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onToggled;
  final Color accentColor;
  final Color backgroundColor;
  final Color activeAccentColor;
  final Color activeBackgroundColor;
  final Color activeThumbColor;

  Toggle({
    super.key,
    required this.value,
    required this.onToggled,
    Color? accentColor,
    Color? backgroundColor,
    Color? activeAccentColor,
    Color? activeBackgroundColor,
    Color? activeThumbColor
  }) : accentColor = accentColor ?? AppColors.onPrimary.withAlpha(150),
       backgroundColor = backgroundColor ?? AppColors.secondary.withAlpha(150),
       activeAccentColor =
           activeAccentColor ?? AppColors.onPrimary.withAlpha(220),
       activeBackgroundColor = activeBackgroundColor ?? Colors.white70,
       activeThumbColor = activeThumbColor ?? Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onToggled,
      inactiveThumbColor: accentColor,
      inactiveTrackColor: backgroundColor,
      trackOutlineColor: WidgetStateProperty.all(accentColor),
      activeTrackColor: activeAccentColor,
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return activeThumbColor;
        }
        return Colors.white70;
      }),
    );
  }
}
