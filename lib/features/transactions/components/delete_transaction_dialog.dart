import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter/material.dart';

class DeleteTransactionDialog extends StatelessWidget {
  final Transaction transaction;

  const DeleteTransactionDialog({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.info_outline_rounded),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bekræft sletning'),
          const SizedBox(height: 8),
          Divider(thickness: 1, color: AppColors.onPrimary),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Er du sikker på du vil slette denne transaktion?'),
          const SizedBox(height: 16),
          Text('Kategori: ${transaction.category.name}'),
          Text('Beløb: ${transaction.amount}'),
          Text('Dato: ${transaction.transactionTime}'),
          Text('Person: ${transaction.user.name}'),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.onPrimary.withAlpha(200)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        )
      ],
    );
  }
}