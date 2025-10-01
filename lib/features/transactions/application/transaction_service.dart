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

  Future<bool> deleteTransactionById(String id) async {
    return await transactionRepository.deleteTransactionById(id);
  }
}

