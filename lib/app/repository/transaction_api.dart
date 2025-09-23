import 'package:expense_tracker/domain/transaction.dart';

abstract class TransactionApi {
  Future<List<Transaction>> getAllTransactions();
  Future<void> postTransaction(Transaction transaction);
  Stream<List<Transaction>> getTransactionsStream();
  Stream<List<Transaction>> getTransactionStreamInRange(DateTime start, DateTime end);
  Future<void> deleteTransaction(String id);
}
