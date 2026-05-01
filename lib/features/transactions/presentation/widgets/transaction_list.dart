import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

import '../../../../domain/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Future<void> Function(Transaction) onDelete;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (_, _) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Divider(color: AppColors.primaryText.withAlpha(80))
      ),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return Dismissible(
          confirmDismiss: (_) async {
            await onDelete(tx);
            return false;
          },
          key: ValueKey(tx.id),
          child: TransactionTile(transaction: tx),
        );
      },
    );
  }
}
