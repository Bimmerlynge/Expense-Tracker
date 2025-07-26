import 'package:expense_tracker/domain/category.dart';

enum TransactionType {
  expense,
  income
}

class Transaction {
  int? id;
  DateTime? createdTime;
  int amount;
  Category category;
  TransactionType type;

  Transaction({
    this.id,
    this.createdTime,
    required this.amount,
    required this.category,
    required this.type,
  });
}