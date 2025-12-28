import 'package:expense_tracker/features/common/widget/empty_list_text.dart';
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
    if (transactions.isEmpty) {
      return const Center(
        child: EmptyListText(text: 'Ingen transaktioner for perioden'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      itemCount: transactions.length,
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
