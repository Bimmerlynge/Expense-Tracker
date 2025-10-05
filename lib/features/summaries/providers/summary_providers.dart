import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMonthProvider = StateProvider<int>((ref) {
  final transactionRange = ref.read(transactionRangeProvider.notifier);

  return DateTime
      .now()
      .month;
});

final showOnlyMineProvider = StateProvider<bool>((ref) => false);
