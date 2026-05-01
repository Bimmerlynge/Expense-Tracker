import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button_inverted.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/extensions/date_utils_extensions.dart';
import 'package:flutter/material.dart';

class DeleteTransactionModal extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;

  const DeleteTransactionModal({
    super.key,
    required this.transaction,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
        iconData: Icons.info_outline,
        title: 'Bekræft sletning',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Vil du slette denne transaktion?',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primary),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                createRow('Kategori', transaction.category.name),
                createRow('Beløb', transaction.amount.toString()),
                createRow(
                  'Dato',
                  transaction.transactionTime!.formatDate(),
                ),
                createRow('Person', transaction.user.name),
              ],
            ),
          ],
        ),
        actions: Row(
          children: [
            Expanded(
              child: PremiumBlueButtonInverted(
                  height: 30,
                  text: 'Fortryd',
                  onTap: () => Navigator.of(context).pop(false)
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
                child: PremiumBlueButton(
                    height: 30,
                    text: 'Slet',
                    onTap: onDelete,
                    linearBegin: Alignment.topLeft,
                    linearEnd: Alignment.bottomRight,
                )
            )
          ],
        )
    );
  }

  Row createRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            title,
            style: TextStyle(
                color: AppColors.primarySecondText
            ),
        ),
        Text(
            value,
            style: TextStyle(
                color: AppColors.primarySecondText
            ),
        )
      ],
    );
  }
}
