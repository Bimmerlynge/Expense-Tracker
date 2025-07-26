import 'package:expense_tracker/app/network/transaction_api.dart';
import 'package:expense_tracker/domain/transaction.dart';

class TransactionViewModel {
  final TransactionApi transactionApi;

  List<Transaction> transactions = [];

  TransactionViewModel(this.transactionApi);

  Future<void> loadTransactions() async {
    transactions = await transactionApi.getAllTransactions();
  }


}