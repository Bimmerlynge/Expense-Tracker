import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Toggle extends StatefulWidget {
  final bool initState;
  final Color accentColor;
  final Color backgroundColor;
  final Color activeAccentColor;
  final Color activeBackgroundColor;
  final ValueChanged<bool> onToggled;

  Toggle({
    super.key,
    this.initState = false,
    required this.onToggled,
    Color? accentColor,
    Color? backgroundColor,
    Color? activeAccentColor,
    Color? activeBackgroundColor,
  }) : accentColor = accentColor ?? AppColors.onPrimary.withAlpha(150),
       backgroundColor = backgroundColor ?? AppColors.secondary.withAlpha(150),
       activeAccentColor =
           activeAccentColor ?? AppColors.onPrimary.withAlpha(220),
       activeBackgroundColor = activeBackgroundColor ?? Colors.white70;

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initState;
  }

  void _onToggle(bool val) {
    setState(() => _value = val);
    widget.onToggled.call(val);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: _onToggle,
      inactiveThumbColor: widget.accentColor,
      inactiveTrackColor: widget.backgroundColor,
      trackOutlineColor: WidgetStateProperty.all(widget.accentColor),
      activeTrackColor: widget.activeAccentColor,
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return widget.activeBackgroundColor;
        }
        return widget.activeAccentColor;
      }),
    );
  }
}
