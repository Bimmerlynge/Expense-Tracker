import 'dart:async';

import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/transactions/service/fixed_expense_firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseViewModel extends StateNotifier<AsyncValue<List<FixedExpense>>> {
  final FixedExpenseFirebaseService _fixedExpenseFirebaseService;
  late final Stream<List<FixedExpense>> _fixedExpensesStream;
  late final StreamSubscription _subscription;

  FixedExpenseViewModel(this._fixedExpenseFirebaseService) : super(const AsyncValue.loading()) {
    _fixedExpensesStream = _fixedExpenseFirebaseService.getFixedExpensesStream();

    _subscription = _fixedExpensesStream.listen(
        (fixedExpenses) => state = AsyncValue.data(fixedExpenses),
      onError: (error, stack) => state = AsyncValue.error(error, stack)
    );
  }

  void updateFixedExpense(FixedExpense updatedFixedExpense) {
    _fixedExpenseFirebaseService.updateFixedExpense(updatedFixedExpense);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}