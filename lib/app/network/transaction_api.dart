import 'package:expense_tracker/domain/transaction.dart';

abstract class TransactionApi {
  Future<List<Transaction>> getAllTransactions();
  Future<void> postTransaction(Transaction transaction);
}