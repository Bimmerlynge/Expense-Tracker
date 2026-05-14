import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/features/common/application/local_storage_service.dart';
import 'package:expense_tracker/features/summaries/application/summary_service.dart';
import 'package:expense_tracker/features/summaries/domain/graph_range.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_list.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_spending.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showOnlyMyHistoryProvider = StateProvider<bool>((ref) => false);
final graphRangeHistoryProvider = StateProvider<GraphRange>((ref) => GraphRange.sixMonths);

final historicListProvider = Provider<HistoricCategoryList>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final transactions = ref.watch(historicListAsync);
  final onlyMine = ref.watch(showOnlyMyHistoryProvider);

  return transactions.maybeWhen(
    data: (items) {
      var transactions = items;

      if (onlyMine) {
        transactions = items.where((item) => item.user.id == currentUser.id).toList();
      }

        return HistoricCategoryList()
               ..addAll(transactions);
    },
    orElse: HistoricCategoryList.new,
  );
});

final historicListAsync = StreamProvider((ref) {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month + 1, 1);
  final start = DateTime(end.year, end.month - 6, 1);

  return ref.watch(summaryServiceProvider).getTransactionsInRange(start, end).asStream();
});

final selectListProvider = StateProvider<List<String>>((ref) {
  return ref.read(localStorageService).getSelectedHistoricCategories();
});

final historicListSelectedCategoriesProvider = StateProvider<List<HistoricCategorySpending>>((ref) {
  final list = ref.watch(historicListProvider);
  final selectList = ref.watch(selectListProvider);

  if (list.getAll().isEmpty) return List.empty();

  final selectHistoricList = list.getAll()
      .where((item) => selectList.contains(item.category.name))
      .toList();

  return selectHistoricList;
});

final filteredHistoricListProvider = Provider<List<HistoricCategorySpending>>((ref) {
  final selectedList = ref.watch(historicListSelectedCategoriesProvider);

  return selectedList;
});