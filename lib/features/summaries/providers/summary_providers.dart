import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMonthProvider = StateProvider<int>((ref) {
  return DateTime.now().month;
});

final showOnlyMineProvider = StateProvider<bool>((ref) => false);
