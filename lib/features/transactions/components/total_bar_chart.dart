import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class TotalBarChart extends StatelessWidget {
  final List<CategorySpending> categorySpendingList;

  const TotalBarChart({super.key, required this.categorySpendingList});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: SizedBox(
        height: 350,
        child: BarChart(
          BarChartData(
            rotationQuarterTurns: 1,
            barGroups: _buildBarGroups(),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 80,
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < categorySpendingList.length) {
                      return SideTitleWidget(

                          meta: meta,
                          child: Text(
                              categorySpendingList[index].name,
                              textAlign: TextAlign.end,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis
                            ),
                          )
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
              )
            )
          )
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(categorySpendingList.length, (i) {
      final item = categorySpendingList[i];
      return BarChartGroupData(
        showingTooltipIndicators: [1, 2],
          x: i,
          barRods: [
            BarChartRodData(
                toY: item.total,



            )
          ]
      );
    });
  }
}
