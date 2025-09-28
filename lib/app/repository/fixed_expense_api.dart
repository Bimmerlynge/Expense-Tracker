import 'package:expense_tracker/domain/fixed_expense.dart';

abstract class FixedExpenseApi {
  Stream<List<FixedExpense>> getFixedExpensesStream();
  Future<void> updateFixedExpense(FixedExpense fixedExpense);
}