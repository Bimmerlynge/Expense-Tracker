import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/transactions/components/add_fixed_expense_popup.dart';
import 'package:expense_tracker/features/transactions/components/fixed_expense_card.dart';
import 'package:expense_tracker/features/transactions/providers/fixed_expense_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpensesTab extends ConsumerStatefulWidget {
  const FixedExpensesTab({super.key});

  @override
  ConsumerState<FixedExpensesTab> createState() => _FixedExpensesTabState();
}

class _FixedExpensesTabState extends ConsumerState<FixedExpensesTab> {


  @override
  Widget build(BuildContext context) {
    final fixedExpenses = ref.watch(fixedExpenseViewModelProvider);

    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Mine faste udgifter',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        SizedBox(height: 8,),
        OutlinedButton(
            onPressed: _showAddFixedExpensePopup,
            child: Text('Opret fast udgift')
        ),
        Expanded(
          child: fixedExpenses.when(
            data: (expenses) => _buildList(expenses),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Fejl: $err')),
          ),
        ),
      ],
    );
  }

  void _showAddFixedExpensePopup() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AddFixedExpensePopup();
        }
    );
  }

  Widget _buildList(List<FixedExpense> expenses) {
    if (expenses.isEmpty) {
      return const Center(child: Text('Ingen faste udgifter endnu'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return FixedExpenseCard(
            key: ValueKey(expense.id),
            expense: expenses[index]
        );
      },
    );
  }
}
