import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/transactions/view_model/fixed_expense_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fixedExpenseViewModelProvider = StateNotifierProvider<
  FixedExpenseViewModel, AsyncValue<List<FixedExpense>>
>((ref) {
  final service = ref.watch(fixedExpenseFirestoreServiceProvider);
  return FixedExpenseViewModel(service);
});