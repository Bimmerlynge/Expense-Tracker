import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/common/widget/empty_list_text.dart';
import 'package:expense_tracker/features/fixed_expenses/components/fixed_expense_card_new.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/collapsed_fixed_expenses_controller.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/fixed_expense_list_screen_controller.dart';
import 'package:expense_tracker/features/fixed_expenses/providers/fixed_expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseListScreen extends ConsumerStatefulWidget {
  const FixedExpenseListScreen({super.key});

  @override
  ConsumerState<FixedExpenseListScreen> createState() => _FixedExpenseListScreenState();
}

class _FixedExpenseListScreenState extends ConsumerState<FixedExpenseListScreen> {

  @override
  Widget build(BuildContext context) {
    final fixedExpenseList = ref.watch(
      fixedExpenseListProvider,
    );
    final collapsedExpenses = ref.watch(
      collapsedFixedExpensesControllerProvider,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _buildList(fixedExpenseList, collapsedExpenses),
    );
  }

  Widget _buildList(
      List<FixedExpense> expenses,
      List<String> collapsedExpenses,
      ) {
    if (expenses.isEmpty) {
      return Center(
        child: EmptyListText(text: 'Ingen faste udgifter defineret'),
      );
    }

    return ListView.separated(
      separatorBuilder: (_, _) => SizedBox(height: 16),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return FixedExpenseCardNew(
            key: ValueKey(expense.id),
            fixedExpense: expense,
            isExpanded: !collapsedExpenses.contains(expense.id),
            onChanged: _fixedExpenseChanged,
            onManualPay: _onManualPay,
            onToggleCollapse: _toggleFixedExpenseCollapse,
        );
      },
    );
  }

  Future<void> _fixedExpenseChanged(FixedExpense expense) async {
    await ref
        .read(fixedExpenseListScreenControllerProvider.notifier)
        .updateExpense(expense);
  }

  Future<void> _onManualPay(FixedExpense expense) async {
    await ref
        .read(fixedExpenseListScreenControllerProvider.notifier)
        .payFixedExpense(expense);

    ToastService.showSuccessToast('Fast udgift registreret!');
  }

  void _toggleFixedExpenseCollapse(String expenseId) {
    ref
        .read(collapsedFixedExpensesControllerProvider.notifier)
        .toggle(expenseId);
  }
}
