import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeleteTransactionDialog extends StatelessWidget {
  final Transaction transaction;

  const DeleteTransactionDialog({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    Row createRow(String title, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const Text('Vil du slette denne transaktion?', textAlign: TextAlign.center,),
              const SizedBox(height: 30),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  createRow('Kategori', transaction.category.name),
                  createRow('Beløb', transaction.amount.toString()),
                  createRow('Dato', DateFormat('dd-MM-yyyy').format(transaction.transactionTime!)),
                  createRow('Person', transaction.user.name)
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