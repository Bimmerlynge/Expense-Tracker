import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:flutter/material.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final Category category;

  const DeleteCategoryDialog({super.key, required this.category});

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

    return AlertDialog(
      icon: const Icon(Icons.info_outline_rounded),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bekræft sletning'),
          const SizedBox(height: 8),
          Divider(thickness: 1, color: AppColors.onPrimary),
        ],
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
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
          )
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Afbryd',
                style: TextStyle(color: AppColors.onPrimary.withAlpha(200)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Slet',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        )
      ],
    );
  }
}