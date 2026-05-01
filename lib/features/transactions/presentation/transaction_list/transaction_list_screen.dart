import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/actions_row.dart';
import 'package:expense_tracker/app/shared/components/multi_select_widget.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/design_system/modals/delete_transaction_modal.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          _actions(),
          _buildList(),
        ],
      ),
    );
  }

  Widget _actions() {
    final filter = ref.watch(transactionFilterProvider);

    return ActionsRow(
      alignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Toggle(
              activeAccentColor: AppColors.primary,
              backgroundColor: AppColors.primaryText,
              accentColor: AppColors.primaryText,
              value: filter.onlyMine,
              onToggled: (val) {
                ref.read(transactionFilterProvider.notifier).state =
                    filter.copyWith(onlyMine: val);
              },
            ),
            Text('Vis kun mit', style: TextStyle(color: AppColors.containerOnPrimary)),
          ],
        ),
        IconButton(onPressed: _onFilterEdit, icon: Icon(Icons.rule, color: AppColors.primary,)),
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

  Widget _buildList() {
    final transactions = ref.watch(filteredTransactionList);

    if (transactions.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Expanded(
      child: TransactionList(
          transactions: transactions,
          onDelete: _handleOnDelete,
        )
    );
  }

  Future<void> _handleOnDelete(Transaction transaction) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => DeleteTransactionModal(
        transaction: transaction,
        onDelete: () async {
          await _deleteTransaction(transaction);
        },
      ),
    );
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    try {
      await controller.deleteTransaction(transaction.id!);
      ToastService.showSuccessToast("Transaction was deleted!");
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ToastService.showErrorToast("Failed to delete transaction.");
    }
  }
}
