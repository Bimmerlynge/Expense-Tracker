import 'package:expense_tracker/app/network/transaction_api.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';

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

class TransactionViewModel {
  final TransactionFirebaseService service;

  List<Transaction> transactions = [];

  TransactionViewModel(this.service);

  static Future<TransactionViewModel> create(TransactionFirebaseService service) async {
    final viewModel = TransactionViewModel(service);
    await viewModel._loadTransactions();
    return viewModel;
  }

  Future<void> _loadTransactions() async {
    transactions = await service.getAllTransactions();
  }

  List<CategorySpending> getCategorySpendingList() {
    print('Getting category spendings');
    final Map<Category, double> categoryTotals = {};

    for (var transaction in transactions) {
      categoryTotals.update(
          transaction.category,
          (existing) => existing + transaction.amount,
          ifAbsent: () => transaction.amount
      );
    }

    final double totalAmount = categoryTotals.values.fold(0, (sum, value) => sum + value);

    return categoryTotals.entries.map((entry) {
      return CategorySpending(
          name: entry.key.name,
          total: entry.value,
          percentage: entry.value / totalAmount);
    }).toList();
  }

  void addTransaction(Transaction transaction) {
    service.postTransaction(transaction);
  }
}