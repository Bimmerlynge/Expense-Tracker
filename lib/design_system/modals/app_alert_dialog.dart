import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Widget content;
  final Widget actions;

  const AppAlertDialog({
    super.key,
    required this.iconData,
    required this.title,
    required this.content,
    required this.actions
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(iconData),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(color: AppColors.primarySecondText),),
          const SizedBox(height: 8),
          Divider(thickness: 1, color: AppColors.secondary.withAlpha(50)),
        ],
      ),
      content: content,
      actions: [
        Divider(color: AppColors.secondary.withAlpha(50)),
        SizedBox(height: 16,),
        actions
      ],
    );
  }
}
