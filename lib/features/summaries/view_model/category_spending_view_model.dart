import 'dart:async';

import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/category_spending.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/providers/summary_providers.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySpendingViewModel extends StateNotifier<List<CategorySpending>> {
  final TransactionFirebaseService service;
  final Ref ref;
  StreamSubscription? _subscription;
  List<Transaction> _lastestTransactions = [];

  CategorySpendingViewModel(this.service, this.ref) : super([]) {
    ref.listen(selectedMonthProvider, (prev, next) {
      _subscription?.cancel();
      listenToCategorySpendingChange(next);
    });

    ref.listen(showOnlyMineProvider, (prev, next) {
      state = _mapCategorySpendingList(_lastestTransactions);
    });

    final currentMonth = ref.read(selectedMonthProvider);
    listenToCategorySpendingChange(currentMonth);
  }

  void listenToCategorySpendingChange(int month) async {
    final now = DateTime.now();

    final start = DateTime(now.year, month, 1);
    final end = DateTime(now.year, month + 1, 1);

    _subscription = service.getTransactionStreamInRange(start, end)
      .listen((transactions) {
        _lastestTransactions = transactions;
        state = _mapCategorySpendingList(transactions);
    });
  }

  List<CategorySpending> _mapCategorySpendingList(
      List<Transaction> transactions) {

    final showOnlyCurrentUser = ref.read(showOnlyMineProvider);
    final currentUser = ref.read(currentUserProvider);

    Map<Category, double> categoryTotals = {};

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) continue;

      if (showOnlyCurrentUser && transaction.user.id != currentUser.id) continue;

      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals.entries.map(
            (entry) =>
            CategorySpending(
                name: entry.key.name, total: entry.value)
    ).toList();
  }



  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
