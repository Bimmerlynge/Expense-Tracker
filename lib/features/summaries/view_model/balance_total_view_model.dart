import 'dart:async';

import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/balance_total.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/providers/summary_providers.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceTotalViewModel extends StateNotifier<List<Transaction>> {
  final Ref _ref;

  BalanceTotalViewModel(this._ref) : super([]) {
    _ref.listen(selectedMonthProvider, (prev, next) {
      listenToTransactionStreamChange(next);
    });

    listenToTransactionStreamChange(1);
  }

  void listenToTransactionStreamChange(int month) {
    _ref.listen<AsyncValue<List<Transaction>>>(
      transactionStreamInRangeProvider,
          (previous, next) {
        next.when(
          data: (transactions) => state = transactions,
          loading: () => state = [],
          error: (e, _) => state = [],
        );
      },
      fireImmediately: true,
    );
  }

  BalanceTotal getBalanceTotal(Person person) {
    return BalanceTotal(income: 2567, expense: 3769);
  }
}