import 'dart:async';

import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySpending {
  String name;
  double total;
  double percentage;

  CategorySpending({
    required this.name,
    required this.total,
    required this.percentage,
  });
}

class TransactionViewModel
    extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionFirebaseService _transactionService;
  late final Stream<List<Transaction>> _transactionStream;
  late final StreamSubscription _subscription;

  TransactionViewModel(this._transactionService, Ref ref)
    : super(const AsyncValue.loading()) {
    _transactionStream = _transactionService.getTransactionsStream();

    _subscription = _transactionStream.listen(
      (transactions) => state = AsyncValue.data(transactions),
      onError: (error, stack) => state = AsyncValue.error(error, stack),
    );
  }

  Future<void> loadTransactions() async {
    try {
      final list = await _transactionService.getAllTransactions();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _transactionService.postTransaction(transaction);
    } catch (e) {
      // no-op
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
