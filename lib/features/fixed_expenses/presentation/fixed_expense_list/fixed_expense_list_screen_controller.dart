import 'dart:async';

import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/fixed_expenses/application/fixed_expenses_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fixed_expense_list_screen_controller.g.dart';

@riverpod
class FixedExpenseListScreenController
    extends _$FixedExpenseListScreenController {

  @override
  void build() {}

  Future<void> updateExpense(FixedExpense expense) async {
    await ref.read(fixedExpenseServiceProvider).updateFixedExpense(expense);
  }

  Future<void> payFixedExpense(FixedExpense expense) async {
    await ref
        .read(fixedExpenseServiceProvider)
        .registerAutoPayFixedExpense(expense);
  }
}
