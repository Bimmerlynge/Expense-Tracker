import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/shared/components/actions_row.dart';
import 'package:expense_tracker/app/shared/components/multi_select_widget.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/transactions/components/delete_transaction_dialog.dart';
import 'package:expense_tracker/features/transactions/domain/transaction_filter.dart';
import 'package:expense_tracker/features/transactions/presentation/widgets/transaction_list.dart';
import 'package:expense_tracker/features/transactions/presentation/transaction_list/transaction_list_screen_controller.dart';
import 'package:expense_tracker/features/transactions/providers/transaction_list_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  late final TransactionListScreenController controller;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transactionFilterProvider.notifier).state = TransactionFilter();
    });
    controller = ref.read(transactionListScreenControllerProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Alle transaktioner',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        _actions(),
        _buildList(),
      ],
    );
  }

  Widget _actions() {
    return ActionsRow(
      alignment: MainAxisAlignment.spaceBetween,
      actions: [
        _showMineToggle(),
        IconButton(onPressed: _onFilterEdit, icon: Icon(Icons.rule))
      ],
    );
  }

  Future<void> _onFilterEdit() async {
    final categories = ref.read(transactionCategoriesProvider);
    final currentFilter = ref.read(transactionFilterProvider);

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return MultiSelectWidget(
            items: categories,
            initialValue: currentFilter.categories.toList(),
            onUpdated: _onFilterUpdated,
          );
        }
    );
  }

  void _onFilterUpdated(List<Category?> updatedCategories) {
    final filter = ref.read(transactionFilterProvider);

    ref.read(transactionFilterProvider.notifier).state =
        filter.copyWith(categories: updatedCategories.whereType<Category>().toSet());
  }

  Widget _showMineToggle() {
    final filter = ref.watch(transactionFilterProvider);

    return Row(
      children: [
        Toggle(
            value: filter.onlyMine,
            onToggled: (val) {
              ref.read(transactionFilterProvider.notifier).state =
                filter.copyWith(onlyMine: val);
            }
        ),
        Text('Vis kun mine', style: TTextTheme.mainTheme.labelSmall),
      ],
    );
  }

  Widget _buildList() {
    final transactionsAsync = ref.watch(
      filteredTransactionList,
    );

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
        },
      ),
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
