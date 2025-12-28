import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';

class EmptyListText extends StatelessWidget {
  final String text;

  const EmptyListText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TTextTheme.mainTheme.bodyMedium);
  }
}
