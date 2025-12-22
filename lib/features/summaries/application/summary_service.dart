import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/categories/application/category_service.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final summaryServiceProvider = Provider<SummaryService>((ref) {
  return SummaryService(
    transactionService: ref.read(transactionServiceProvider),
    categoryService: ref.read(categoryServiceProvider),
    ref: ref
  );
});

class SummaryService {
  final TransactionService transactionService;
  final CategoryService categoryService;
  final Ref ref;

  SummaryService({required this.transactionService, required this.categoryService, required this.ref});

  Stream<List<Transaction>> getTransactionsCurrentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);

    return transactionService.getTransactionsInRange(start, end);
  }

  Future<List<Transaction>> getTransactionsInRange(DateTime start, DateTime end) async {
    return await transactionService.getTransactionInRange(start, end);
  }

  Future<void> updateHistoricLegendColor(Category category) async {
    await categoryService.updateCategoryColor(category);
  }
}