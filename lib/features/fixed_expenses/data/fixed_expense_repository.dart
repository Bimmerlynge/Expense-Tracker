import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fixedExpenseRepositoryProvider = Provider<FixedExpenseRepository>((ref) {
  throw UnimplementedError("FixedExpenseRepository must be overridden");
});

abstract class FixedExpenseRepository {
  Stream<List<FixedExpense>> getFixedExpensesStream();
  Future<void> updateFixedExpense(FixedExpense fixedExpense);
  Future<bool> addFixedExpense(FixedExpense fixedExpense);
}
