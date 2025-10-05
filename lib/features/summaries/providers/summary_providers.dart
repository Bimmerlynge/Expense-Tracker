import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/view_model/balance_total_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMonthProvider = StateProvider<int>((ref) {
  final transactionRange = ref.read(transactionRangeProvider.notifier);

  return DateTime
      .now()
      .month;
});

final balanceTotalViewModelProvider = StateNotifierProvider<
    BalanceTotalViewModel,
    List<Transaction>>((ref) {

      return BalanceTotalViewModel(ref);
});

final showOnlyMineProvider = StateProvider<bool>((ref) => false);
