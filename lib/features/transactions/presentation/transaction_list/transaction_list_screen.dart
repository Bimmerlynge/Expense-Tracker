import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/extensions/async_value_extensions.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/transactions/components/delete_transaction_dialog.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/transaction_list.dart';
import 'package:expense_tracker/features/transactions/presentation/transaction_list/transaction_list_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  late final TransactionListScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = ref.read(transactionListScreenControllerProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    _listenForControllerStateError();

    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Alle transaktioner',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        _buildList()
      ],
    );
  }

  void _listenForControllerStateError() {
    ref.listen<AsyncValue<List<Transaction>>>(
        transactionListScreenControllerProvider,
            (_, state) => state.showToastOnError()
    );
  }

  Widget _buildList() {
    final transactionsAsync = ref.watch(transactionListScreenControllerProvider);

    return Expanded(
      child: AsyncValueWidget(
        value: transactionsAsync,
        data: (transactions) => TransactionList(
          transactions: transactions,
          onDelete: _handleOnDelete,
        ),
      ),
    );
  }

  Future<void> _handleOnDelete(Transaction transaction) async {
    await showDialog(
        context: context,
        builder: (dialogContext) => DeleteTransactionDialog(
            transaction: transaction,
            onConfirm: () async {
              await _deleteTransaction(transaction);
            }
        )
    );
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      await controller.deleteTransaction(transaction.id!);
      ToastService.showSuccessToast("Transaction was deleted!");
    } catch (e) {
      ToastService.showErrorToast("Failed to delete transaction.");
    }
  }
}
