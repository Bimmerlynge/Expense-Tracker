import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_list.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_spending.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoricChartMapper {
  static late Map<double, DateTime> xToDateMap;

  static List<LineChartBarData> toLineChartDataList(
    HistoricCategoryList list,
    Set<String> hiddenCategories,
  ) {
    final allDates = <DateTime>{};
    for (final entry in list.getAll()) {
      allDates.addAll(entry.dataSet.keys);
    }

    for (final historic in list.getAll()) {
      for (final date in allDates) {
        historic.dataSet.putIfAbsent(
          date,
          () => CategorySpending(name: historic.category.name),
        );
      }
    }

    final sortedDates = allDates.toList()..sort((a, b) => a.compareTo(b));

    xToDateMap = {};
    double index = 1;
    for (final date in sortedDates) {
      xToDateMap[index] = date;
      index++;
    }

    final dataList = list
        .getAll()
        .where((item) => !hiddenCategories.contains(item.category.name))
        .map((item) => _toLineChartBarData(item))
        .toList();

    return dataList;
  }

  static LineChartBarData _toLineChartBarData(
    HistoricCategorySpending spending,
  ) {
    final entries = spending.dataSet.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final spots = entries.map((entry) {
      final spot = FlSpot(
        xToDateMap.entries
            .firstWhere(
              (e) =>
                  e.value.year == entry.key.year &&
                  e.value.month == entry.key.month,
            )
            .key,
        entry.value.total,
      );
      return spot;
    }).toList();

    return LineChartBarData(
      spots: spots,
      color: spending.category.color ?? Colors.grey,
    );
  }

  static List<Category> categories(List<HistoricCategorySpending> list) {
    return list.map((l) => l.category).toList();
  }
}
