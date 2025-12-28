import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending.dart';

class CategorySpendingList {
  List<CategorySpending> list = [];

  List<CategorySpending> getAll() => list;
  List<String> getAllCategories() => list.map((c) => c.name).toList();

  void addToList(Transaction transaction) {
    if (transaction.type == TransactionType.income) return;
    final existingCategory = _getOrCreateCategory(transaction.category);
    existingCategory.insertTransaction(transaction);
  }

  CategorySpending _getOrCreateCategory(Category category) {
    return list.firstWhere(
      (c) => c.name == category.name,
      orElse: () {
        final newCategory = CategorySpending(name: category.name);

        list.add(newCategory);
        return newCategory;
      },
    );
  }

  CategorySpendingList filter(List<bool Function(Transaction)> predicates) {
    final filtered = CategorySpendingList();

    for (final cs in list) {
      final txs = cs.transactions.where((t) {
        return predicates.every((predicate) => predicate(t));
      }).toList();

      if (txs.isEmpty) continue;

      final newCategory = CategorySpending(name: cs.name);
      for (final tx in txs) {
        newCategory.insertTransaction(tx);
      }
      filtered.list.add(newCategory);
    }

    return filtered;
  }
}
