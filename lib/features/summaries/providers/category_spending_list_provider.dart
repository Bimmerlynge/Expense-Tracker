import 'package:expense_tracker/features/summaries/domain/category_spending_list.dart';
import 'package:expense_tracker/features/summaries/providers/category_spending_list_async_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_spending_list_provider.g.dart';

@riverpod
CategorySpendingList categorySpendingList(Ref ref) {
  final listAsync = ref.watch(categorySpendingListAsyncProvider);

  return listAsync.maybeWhen(
      data: (list) => list,
      orElse: () => CategorySpendingList());
}
