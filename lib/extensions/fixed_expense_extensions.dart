import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';

extension FixedExpenseTransaction on FixedExpense {
  Transaction toTransaction(Person person) {
    return Transaction(
      user: person,
      amount: amount,
      category: Category.fixedExpense(),
      type: TransactionType.expense,
      transactionTime: nextPaymentDate,
      description: title,
    );
  }
}
