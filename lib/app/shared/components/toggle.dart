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
  final Color? trackOutlineColor;

  Toggle({
    super.key,
    required this.value,
    required this.onToggled,
    Color? accentColor,
    Color? backgroundColor,
    Color? activeAccentColor,
    Color? activeBackgroundColor,
    Color? activeThumbColor,
    this.trackOutlineColor,
  }) : accentColor = accentColor ?? AppColors.primary,
       backgroundColor = backgroundColor ?? AppColors.primaryText.withAlpha(150),
       activeAccentColor = activeAccentColor ?? AppColors.primary,
       activeBackgroundColor = activeBackgroundColor ?? Colors.white70,
       activeThumbColor = activeThumbColor ?? Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onToggled,
      inactiveThumbColor: accentColor,
      inactiveTrackColor: backgroundColor,
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return trackOutlineColor != null
                  ? trackOutlineColor!
                  : activeAccentColor;
            }

            return trackOutlineColor != null
                ? trackOutlineColor!
                : Colors.transparent;}
      ),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return activeAccentColor;
        }

        return backgroundColor;
      }),
      activeTrackColor: activeAccentColor,
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return activeThumbColor;
        }
        return activeThumbColor;
      }),
    );
  }
}
