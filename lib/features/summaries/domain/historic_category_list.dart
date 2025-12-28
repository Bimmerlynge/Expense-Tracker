import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_spending.dart';

class HistoricCategoryList {
  List<HistoricCategorySpending> list = [];

  List<HistoricCategorySpending> getAll() => list;

  void addToList(Transaction transaction) {
    if (transaction.type == TransactionType.income) return;
    if (transaction.category.name == Category.fixedExpense().name) return;
    final existingCategory = _getOrCreate(transaction);
    existingCategory.insertTransaction(transaction);
  }

  HistoricCategorySpending _getOrCreate(Transaction transaction) {
    return list.firstWhere(
      (h) => h.category.name == transaction.category.name,
      orElse: () {
        final newEntry = HistoricCategorySpending(
          category: transaction.category,
        );

        list.add(newEntry);
        return newEntry;
      },
    );
  }

  double getMaxAmountSpend(Set<String> hiddenCategories) {
    final maxAmount = list
        .where((h) => !hiddenCategories.contains(h.category.name))
        .expand((h) => h.dataSet.values)
        .map((c) => c.total)
        .fold<double>(0, (max, amount) => amount > max ? amount : max);

    return maxAmount;
  }
}
