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

  double getTotal() {
    return dataSet.values.fold(0.0, (sum, spending) => sum + spending.total);
  }

  double getAverage() {
    final subSet = dataSet.entries.toList().sublist(0, dataSet.entries.length - 1).asMap();
    final total = subSet.values.fold(0.0, (sum, entry) => sum + entry.value.total);
    return total / (dataSet.entries.length - 1);
  }
}
