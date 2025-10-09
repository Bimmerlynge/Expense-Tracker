import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/data/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(
      transactionRepository: ref.watch(transactionRepositoryProvider)
  );
});

class TransactionService {
  final TransactionRepository transactionRepository;

  TransactionService({required this.transactionRepository});

  Stream<List<Transaction>> getAllTransactionsStream() {
    return transactionRepository.getTransactionsStream();
  }

  Stream<List<Transaction>> getTransactionsInRange(DateTime start, DateTime end) {
    return getAllTransactionsStream().map(
        (transactions) => transactions.where(
            (t) => !t.transactionTime!.isBefore(start) &&
                  t.transactionTime!.isBefore(end)
        ).toList()
    );
  }

  Future<bool> deleteTransactionById(String id) async {
    return await transactionRepository.deleteTransactionById(id);
  }

  Future<bool> createTransaction(Transaction transaction) async {
    try {
      await transactionRepository.postTransaction(transaction);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Transaction>> getTransactionInRange(DateTime start, DateTime end) async {
    return await transactionRepository.getTransactionsInRange(start, end);
  }
}

