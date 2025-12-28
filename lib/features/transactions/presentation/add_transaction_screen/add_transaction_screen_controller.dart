import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_transaction_screen_controller.g.dart';

@riverpod
class AddTransactionScreenController extends _$AddTransactionScreenController {
  @override
  void build() {
    // no-op
  }

  Future<void> createTransaction(Transaction transaction) async {
    try {
      _validateAmount(transaction.amount);
      ref.read(transactionServiceProvider).createTransaction(transaction);
    } catch (e) {
      rethrow;
    }
  }

  void _validateAmount(double value) {
    if (value <= 0) {
      throw ArgumentError('Beløb kan ikke være 0 eller mindre');
    }
  }
}
