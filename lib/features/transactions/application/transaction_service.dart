import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending_list.dart';
import 'package:expense_tracker/features/transactions/data/transaction_repository.dart';
import 'package:expense_tracker/features/transactions/domain/line_item.dart';
import 'package:expense_tracker/features/transactions/domain/receipt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(
    transactionRepository: ref.watch(transactionRepositoryProvider),
  );
});

class TransactionService {
  final TransactionRepository transactionRepository;

  TransactionService({required this.transactionRepository});

  Stream<List<Transaction>> getAllTransactionsStream() {
    return transactionRepository.getTransactionsStream();
  }

  Stream<List<Transaction>> getTransactionsInRange(
    DateTime start,
    DateTime end,
  ) {
    return getAllTransactionsStream().map(
      (transactions) => transactions
          .where(
            (t) =>
                !t.transactionTime!.isBefore(start) &&
                t.transactionTime!.isBefore(end),
          )
          .toList(),
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

  Future<List<Transaction>> getTransactionInRange(
    DateTime start,
    DateTime end,
  ) async {
    return await transactionRepository.getTransactionsInRange(start, end);
  }

  Future<void> processReceipt(Receipt receipt) async {
    _applyDiscounts(receipt);
    final transactionList = _mapFromReceipt(receipt);
    await transactionRepository.postTransactionList(transactionList);
  }

  void _applyDiscounts(Receipt receipt) {
    for (var discount in receipt.unresolvedDiscounts) {
      final appliedItem = discount.appliedTo;
      if (appliedItem == null) continue;

      final item = receipt.getLineItemById(appliedItem.id!);
      item.price = double.parse((item.price - discount.amount).toStringAsFixed(2));
    }
  }

  List<Transaction> _mapFromReceipt(Receipt receipt) {
    List<Transaction> list = receipt.items
        .map((item) => _fromLineItem(receipt.user!, item)).toList();
    CategorySpendingList categorySpendingList = CategorySpendingList();

    for (final tx in list) {
      categorySpendingList.addToList(tx);
    }

    return _fromCategorySpendingList(receipt, categorySpendingList);
  }

  List<Transaction> _fromCategorySpendingList(Receipt receipt, CategorySpendingList spendingList) {
    return spendingList.list.map((spending) => Transaction(
        user: receipt.user!,
        transactionTime: receipt.date,
        amount: spending.total,
        category: Category(name: spending.name),
        type: TransactionType.expense)
    ).toList();
  }

  Transaction _fromLineItem(Person user, LineItem lineItem) {
    return Transaction(
        user: user,
        amount: lineItem.price,
        category: lineItem.category!,
        type: TransactionType.expense
    );
  }


}
