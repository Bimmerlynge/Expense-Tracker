import 'package:expense_tracker/domain/transaction.dart';

class CategorySpending {
  String name;
  late double total;
  late List<Transaction> transactions;

  CategorySpending({required this.name}) {
    transactions = [];
    total = 0;
  }

  void insertTransaction(Transaction transaction) {
    transactions.add(transaction);
    if (transaction.type == TransactionType.income) return;

    total += transaction.amount;
  }
}
