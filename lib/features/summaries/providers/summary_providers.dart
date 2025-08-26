import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category_spending.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/view_model/balance_total_view_model.dart';
import 'package:expense_tracker/features/summaries/view_model/category_spending_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMonthProvider = StateProvider<int>((ref) {
  final transactionRange = ref.read(transactionRangeProvider.notifier);



  return DateTime
      .now()
      .month;
});

final categorySpendingViewModelProvider = StateNotifierProvider<
    CategorySpendingViewModel,
    List<CategorySpending>>((ref) {
  final service = ref.read(transactionFirestoreServiceProvider);
  return CategorySpendingViewModel(service, ref);
});

final balanceTotalViewModelProvider = StateNotifierProvider<
    BalanceTotalViewModel,
    List<Transaction>>((ref) {

      return BalanceTotalViewModel(ref);
});