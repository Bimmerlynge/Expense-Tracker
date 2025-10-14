import 'package:expense_tracker/features/summaries/domain/historic_category_list.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_spending.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'historic_chart_filter_controller.g.dart';

@riverpod
class HistoricChartFilterController extends _$HistoricChartFilterController {
  HistoricCategoryList? _originalList;
  final Set<String> _hiddenCategories = {};

  @override
  HistoricCategoryList? build() => null;

  void setData(HistoricCategoryList list) {
    _originalList = _filterLast6Months(list);
    state = _originalList;
  }

  HistoricCategoryList _filterLast6Months(HistoricCategoryList list) {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);

    final filtered = HistoricCategoryList();

    for (final historic in list.getAll()) {
      final filteredSpending = historic.dataSet.entries
          .where((entry) =>
      entry.key.isAfter(sixMonthsAgo) ||
          _isSameMonth(entry.key, sixMonthsAgo))
          .toList();

      if (filteredSpending.isNotEmpty) {
        final newHistoric =
        HistoricCategorySpending(category: historic.category);
        for (final entry in filteredSpending) {
          newHistoric.dataSet[entry.key] = entry.value;
        }
        filtered.list.add(newHistoric);
      }
    }
    return filtered;
  }

  bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  void toggleCategory(String categoryName) {
    if (_hiddenCategories.contains(categoryName)) {
      _hiddenCategories.remove(categoryName);
    } else {
      _hiddenCategories.add(categoryName);
    }

    state = HistoricCategoryList()..list.addAll(_originalList!.getAll());
  }

  bool isCategoryHidden(String categoryName) =>
      _hiddenCategories.contains(categoryName);

  Set<String> get hiddenCategories => _hiddenCategories;

}