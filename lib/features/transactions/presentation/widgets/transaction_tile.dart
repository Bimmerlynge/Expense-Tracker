import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/extensions/date_utils_extensions.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.type == TransactionType.expense
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: transaction.type == TransactionType.expense
            ? Colors.red
            : Colors.green,
      ),
      title: (transaction.description?.isNotEmpty ?? false)
          ? Text('${transaction.category.name} - ${transaction.description}')
          : Text(transaction.category.name),
      subtitle: Text(
          '${transaction.transactionTime!.formatDate()} \n${transaction.user.name}'),
      trailing: Text('${transaction.amount} DKK'),
    );
  }
}
