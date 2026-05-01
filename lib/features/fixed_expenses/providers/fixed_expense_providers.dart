import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/fixed_expenses/application/fixed_expenses_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fixedExpenseStreamProvider = StreamProvider<List<FixedExpense>>((ref) {
  return ref.watch(fixedExpenseServiceProvider).getAllFixedExpensesStream();
});

final fixedExpenseListProvider = Provider<List<FixedExpense>>((ref) {
  final fixedExpensesAsync = ref.watch(fixedExpenseStreamProvider);

  return fixedExpensesAsync.maybeWhen(
      data: (list) => list,
      orElse: () => []);
});