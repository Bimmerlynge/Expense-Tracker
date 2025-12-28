import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending.dart';

class HistoricCategorySpending {
  Category category;

  Map<DateTime, CategorySpending> dataSet = {};

  HistoricCategorySpending({required this.category});

  void insertTransaction(Transaction transaction) {
    final dataKey = dataSet.putIfAbsent(
      DateTime(
        transaction.transactionTime!.year,
        transaction.transactionTime!.month,
      ),
      () => CategorySpending(name: transaction.category.name),
    );

    dataKey.insertTransaction(transaction);
  }
}
