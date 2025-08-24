import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category_spending.dart';
import 'package:expense_tracker/features/summaries/view_model/category_spending_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMonthProvider = StateProvider<int>((ref) {
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