import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionFilterProvider = StateProvider<TransactionFilter>((ref) {
  return TransactionFilter();
});

class TransactionFilter {
  final Set<Category> categories;
  final bool onlyMine;

  TransactionFilter({
    this.categories = const {},
    this.onlyMine = false
  });

  bool matches(Transaction transaction, Person currentUser) {
    if (categories.isNotEmpty && !categories.contains(transaction.category)) {
      return false;
    }

    if (onlyMine && transaction.user.id != currentUser.id) {
      return false;
    }

    return true;
  }

  TransactionFilter copyWith({
    Set<Category>? categories,
    bool? onlyMine,
  }) {
    return TransactionFilter(
      categories: categories ?? this.categories,
      onlyMine: onlyMine ?? this.onlyMine,
    );
  }
}