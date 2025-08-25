import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/features/transactions/components/delete_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/transaction.dart';

class TransactionListView extends ConsumerStatefulWidget {
  const TransactionListView({super.key});

  @override
  ConsumerState<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends ConsumerState<TransactionListView> {
  late final viewModelNotifier = ref.read(transactionViewModelProvider.notifier);

  @override
  Widget build(BuildContext context) {
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
            return Dismissible(
              confirmDismiss: (_) => showDeleteConfirmationDialog(tx),
              onDismissed: (_) => deleteTransaction(tx),
              key: ValueKey(tx.id),
              child: _createTile(tx)
            );
          },
        );
      },
    );
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      await viewModelNotifier.deleteTransaction(transaction.id!);
      ToastService.showSuccessToast(
        context,
        "Transaction was deleted!",
      );
    } catch (e) {
      ToastService.showErrorToast(
        context,
        "Failed to delete transaction.",
      );
    }
  }

  ListTile _createTile(Transaction transaction) {
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
        DateFormat('dd-MM-yyyy').format(transaction.transactionTime!),
      ),
      trailing: Text('${transaction.amount} DKK'),
    );
  }

  Future<bool> showDeleteConfirmationDialog(Transaction transaction) async {
    return await showDialog<bool>(
        context: context,
        builder: (_) => DeleteTransactionDialog(transaction: transaction)
    ) ?? false;
  }
}
