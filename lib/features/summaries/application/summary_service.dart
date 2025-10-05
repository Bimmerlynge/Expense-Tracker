import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final summaryServiceProvider = Provider<SummaryService>((ref) {
  return SummaryService(
    transactionService: ref.read(transactionServiceProvider),
    ref: ref
  );
});

class SummaryService {
  final TransactionService transactionService;
  final Ref ref;

  SummaryService({required this.transactionService, required this.ref});

  Stream<List<Transaction>> getTransactionsCurrentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);

    return transactionService.getTransactionsInRange(start, end);
  }
}