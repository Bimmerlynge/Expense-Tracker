import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/transaction.dart';

class TransactionListView extends ConsumerWidget {
  const TransactionListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final transactionsAsync = ref.watch(transactionViewModelProvider);
    final transactionsAsync = ref.watch(transactionStreamProvider);

    return transactionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(child: Text('No transactions found.'));
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return ListTile(
              leading: Icon(
                tx.type == TransactionType.expense
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: tx.type == TransactionType.expense
                    ? Colors.red
                    : Colors.green,
              ),
              title: Text(tx.category.name),
              subtitle: Text(tx.createdTime?.toIso8601String() ?? ''),
              trailing: Text('${tx.amount} DKK'),
            );
          },
        );
      },
    );
  }
}
