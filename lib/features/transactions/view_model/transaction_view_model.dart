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
    required this.percentage
  });
}

class TransactionViewModel extends StateNotifier<AsyncValue<List<Transaction>>> {
  final TransactionFirebaseService _transactionService;

  TransactionViewModel(this._transactionService) : super(const AsyncValue.loading()) {
    loadTransactions();
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

      await loadTransactions();
    } catch(e) {
      // no-op
    }


  }
}