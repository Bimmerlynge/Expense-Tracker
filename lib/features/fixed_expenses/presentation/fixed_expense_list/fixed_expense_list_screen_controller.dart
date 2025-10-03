import 'dart:async';

import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/fixed_expenses/application/fixed_expenses_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fixed_expense_list_screen_controller.g.dart';

@riverpod
class FixedExpenseListScreenController extends _$FixedExpenseListScreenController {
  late final StreamSubscription<List<FixedExpense>> _subscription;

  @override
  FutureOr<List<FixedExpense>> build() {
    state = const AsyncLoading();

    final service = ref.read(fixedExpenseServiceProvider);
    final stream = service.getAllFixedExpensesStream();

    _subscription = stream.listen(
      (expenses) => state = AsyncData(expenses),
      onError: (error, stack) => state = AsyncError(error, stack),
    );

    ref.onDispose(() => _subscription.cancel());

    return stream.first;
  }

  Future<void> updateExpense(FixedExpense expense) async {
    await ref.read(fixedExpenseServiceProvider).updateFixedExpense(expense);
  }

  Future<void> payFixedExpense(FixedExpense expense) async {
    await ref.read(fixedExpenseServiceProvider).registerAutoPayFixedExpense(expense);
  }
}