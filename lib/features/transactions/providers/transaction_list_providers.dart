import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:expense_tracker/features/transactions/domain/transaction_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showOnlyMyTransactionsProvider = StateProvider<bool>((ref) => false);

final transactionCategoriesProvider = Provider<List<Category>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);

  return transactionsAsync.maybeWhen(
      data: (transactions) {
        final categories = transactions
            .map((t) => t.category)
            .toSet()
            .toList();

        return categories;
      },
      orElse: () => []);
});

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month + 1, 1);
  final start = DateTime(end.year, end.month - 1, 1);


  return ref
      .watch(transactionServiceProvider)
      .getTransactionsInRange(start, end);
});

final filteredTransactionList = Provider<List<Transaction>>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  final filter = ref.watch(transactionFilterProvider);
  final currentUser = ref.watch(currentUserProvider);

  return transactionsAsync.maybeWhen(
      data: (list) => list.where((t) => filter.matches(t, currentUser)).toList(),
      orElse: () => []
  );
});