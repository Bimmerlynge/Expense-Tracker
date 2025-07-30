import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TotalPieChart extends StatelessWidget {
  final List<CategorySpending> categorySpendingList;

  const TotalPieChart({super.key, required this.categorySpendingList});

  @override
  Widget build(BuildContext context) {
    return PieChart(
        PieChartData(
            sections: _buildPieSections(),
            centerSpaceRadius: 10
        )
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    var sorted = List<CategorySpending>.from(categorySpendingList)
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    final topFour = sorted.take(4).toList();
    final remaining = sorted.skip(4).toList();

    final topSections = _buildTopFourSections(topFour);
    final otherSection = [_buildOtherSection(remaining)];
    
    return [...topSections, ...otherSection];
  }

  List<PieChartSectionData> _buildTopFourSections(List<CategorySpending> spendings) {
    return List.generate(spendings.length, (i) {
      var item = spendings[i];
      return PieChartSectionData(
        title: item.name,
        value: item.percentage,
        radius: 120
      );
    });
  }

  PieChartSectionData _buildOtherSection(List<CategorySpending> list) {
    final totalPercentage = list.fold(0.0, (sum, item) => sum + item.percentage);
    return PieChartSectionData(
      title: 'Other',
      value: totalPercentage,
      radius: 120,
    );
  }
}
