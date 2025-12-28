import 'dart:async';

import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/application/summary_service.dart';
import 'package:expense_tracker/features/summaries/domain/balance_total.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'balance_chart_screen_controller.g.dart';

@riverpod
class BalanceChartScreenController extends _$BalanceChartScreenController {
  late final StreamSubscription<List<BalanceTotal>> _subscription;

  @override
  FutureOr<List<BalanceTotal>> build() {
    state = AsyncLoading();

    final service = ref.read(summaryServiceProvider);
    final stream = service.getTransactionsCurrentMonth().map(_toBalanceTotal);

    _subscription = stream.listen(
      (balanceTotals) => state = AsyncData(balanceTotals),
      onError: (error, stack) => state = AsyncError(error, stack),
    );

    ref.onDispose(() => _subscription.cancel());

    return stream.first;
  }

  List<BalanceTotal> _toBalanceTotal(List<Transaction> transactions) {
    final Map<String, BalanceTotal> totalsByUser = {};

    for (final tx in transactions) {
      _processTransaction(totalsByUser, tx);
    }

    return totalsByUser.values.toList();
  }

  void _processTransaction(
    Map<String, BalanceTotal> totalsByUser,
    Transaction transaction,
  ) {
    final currentTotal =
        totalsByUser[transaction.user.id] ??
        BalanceTotal(person: transaction.user, income: 0, expense: 0);

    final updated = BalanceTotal(
      person: transaction.user,
      income:
          currentTotal.income +
          (transaction.type == TransactionType.income ? transaction.amount : 0),
      expense:
          currentTotal.expense +
          (transaction.type == TransactionType.expense
              ? transaction.amount
              : 0),
    );

    totalsByUser[transaction.user.id] = updated;
  }
}
