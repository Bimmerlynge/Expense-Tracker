import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(label, style: TTextTheme.mainTheme.bodySmall),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
