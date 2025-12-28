import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ActionsRow extends StatelessWidget {
  final Color dividerColor;
  final List<Widget> actions;
  final MainAxisAlignment alignment;

  ActionsRow({
    super.key,
    Color? dividerColor,
    List<Widget>? actions,
    this.alignment = MainAxisAlignment.end,
  }) : dividerColor =
           dividerColor ?? AppColors.primarySecondText.withAlpha(100),
       actions = actions ?? const [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(mainAxisAlignment: alignment, children: actions),
      ),
    );
  }
}
