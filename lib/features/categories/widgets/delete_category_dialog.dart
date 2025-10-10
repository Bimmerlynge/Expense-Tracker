import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:flutter/material.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final Category category;
  final Future<void> Function() onConfirm;

  const DeleteCategoryDialog({
    super.key,
    required this.category,
    required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    Row createRow(String title, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title),
          Text(value)
        ],
      );
    }

    return PopupWidget(
        popupIcon: const Icon(Icons.info_outline_rounded),
        bodyContent: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Vil du slette denne kategori?', textAlign: TextAlign.center,),
            const SizedBox(height: 30),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                createRow('Navn', category.name),
              ],
            )
          ],
        ),
        onConfirm: onConfirm,
        confirmText: "Slet",
        headerTitle: "Bekræft sletning",
    );
  }
}