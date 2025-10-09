import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  throw UnimplementedError("TransactionRepositoryProvider must be overridden");
});

abstract class TransactionRepository {
  Stream<List<Transaction>> getTransactionsStream();
  Future<void> postTransaction(Transaction transaction);
  Future<bool> deleteTransactionById(String id);
  Future<List<Transaction>> getTransactionsInRange(DateTime start, DateTime end);
}