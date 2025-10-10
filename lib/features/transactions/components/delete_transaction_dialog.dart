import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeleteTransactionDialog extends StatelessWidget {
  final Transaction transaction;
  final void Function() onConfirm;

  const DeleteTransactionDialog({
    super.key,
    required this.transaction,
    required this.onConfirm
  });

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

    return PopupWidget(
        popupIcon: const Icon(Icons.info_outline_rounded),
        bodyContent: Column(
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
        ),
        onConfirm: onConfirm,
        confirmText: "Slet",
        headerTitle: "Bekræft sletning",
    );
  }
}