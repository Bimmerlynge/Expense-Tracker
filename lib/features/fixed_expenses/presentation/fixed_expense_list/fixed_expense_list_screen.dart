import 'package:expense_tracker/app/shared/components/actions_row.dart';
import 'package:expense_tracker/app/shared/components/simple_text_button.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/common/widget/empty_list_text.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/collapsed_fixed_expenses_controller.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/fixed_expense_list_screen_controller.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/add_fixed_expense/add_fixed_expense_popup.dart';
import 'package:expense_tracker/features/fixed_expenses/components/fixed_expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseListScreen extends ConsumerStatefulWidget {
  const FixedExpenseListScreen({super.key});

  @override
  ConsumerState<FixedExpenseListScreen> createState() =>
      _FixedExpenseListScreenState();
}

class _FixedExpenseListScreenState
    extends ConsumerState<FixedExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    final fixedExpensesAsync = ref.watch(
      fixedExpenseListScreenControllerProvider,
    );
    final collapsedExpenses = ref.watch(
      collapsedFixedExpensesControllerProvider,
    );

    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Mine faste udgifter',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        SizedBox(height: 8),
        _actions(),
        Expanded(
          child: AsyncValueWidget(
            value: fixedExpensesAsync,
            data: (expenses) => _buildList(expenses, collapsedExpenses),
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    return ActionsRow(
      actions: [
        SimpleTextButton(
          iconData: Icons.add,
          onPress: _showAddFixedExpensePopup,
          labelText: 'Opret fast udgift',
        ),
      ],
    );
  }

  void _showAddFixedExpensePopup() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AddFixedExpensePopup();
      },
    );
  }

  Widget _buildList(
    List<FixedExpense> expenses,
    List<String> collapsedExpenses,
  ) {
    if (expenses.isEmpty) {
      return Center(
        child: EmptyListText(text: 'Ingen fase udgifter defineret'),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return FixedExpenseCard(
          key: ValueKey(expense.id),
          expense: expenses[index],
          onChanged: _fixedExpenseChanged,
          onToggleCollapse: _toggleFixedExpenseCollapse,
          isExpanded: !collapsedExpenses.contains(expense.id),
          onManualPay: _onManualPay,
        );
      },
    );
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

  Future<void> _fixedExpenseChanged(FixedExpense expense) async {
    await ref
        .read(fixedExpenseListScreenControllerProvider.notifier)
        .updateExpense(expense);
  }
}
