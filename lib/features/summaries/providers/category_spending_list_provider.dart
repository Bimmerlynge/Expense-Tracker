import 'package:expense_tracker/features/summaries/domain/category_spending_list.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/category_chart_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_spending_list_provider.g.dart';

@riverpod
CategorySpendingList categorySpendingList(Ref ref) {
  final listAsync = ref.watch(categoryChartScreenControllerProvider);

  return listAsync.maybeWhen(
      data: (list) => list,
      orElse: () => CategorySpendingList());
}
