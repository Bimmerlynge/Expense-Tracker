import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:flutter/material.dart';

class DeleteGoalDialog extends StatelessWidget {
  final Goal goal;
  final Future<void> Function() onConfirm;

  const DeleteGoalDialog({
    super.key,
    required this.goal,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    Row createRow(String title, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(title), Text(value)],
      );
    }

    return PopupWidget(
      popupIcon: const Icon(Icons.info_outline_rounded),
      bodyContent: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Vil du slette dette opsparingsmål?',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [createRow('Titel', goal.title)],
          ),
        ],
      ),
      onConfirm: onConfirm,
      confirmText: "Slet",
      headerTitle: "Bekræft sletning",
    );
  }
}
