import 'dart:async';

import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_list_screen_controller.g.dart';

@Riverpod(keepAlive: true)
class TransactionListScreenController
    extends _$TransactionListScreenController {

  @override
  void build() {

  }

  Future<bool> deleteTransaction(String transactionId) async {
    final service = ref.read(transactionServiceProvider);
    return await service.deleteTransactionById(transactionId);
  }
}
