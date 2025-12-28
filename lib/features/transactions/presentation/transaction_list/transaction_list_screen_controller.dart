import 'dart:async';

import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_list_screen_controller.g.dart';

@Riverpod(keepAlive: true)
class TransactionListScreenController
    extends _$TransactionListScreenController {
  late final StreamSubscription<List<Transaction>> _subscription;

  @override
  FutureOr<List<Transaction>> build() {
    state = const AsyncLoading();

    final service = ref.read(transactionServiceProvider);
    final stream = service.getAllTransactionsStream();

    _subscription = stream.listen(
      (transactions) => state = AsyncData(transactions),
      onError: (error, stack) => state = AsyncError(error, stack),
    );

    ref.onDispose(() => _subscription.cancel());

    return stream.first;
  }

  Future<bool> deleteTransaction(String transactionId) async {
    final service = ref.read(transactionServiceProvider);
    return await service.deleteTransactionById(transactionId);
  }
}
