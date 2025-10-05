import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending.dart';
import 'package:expense_tracker/features/common/widget/empty_list_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryBarChart extends StatelessWidget {
  final List<CategorySpending> categorySpendingList;

  CategoryBarChart({super.key, required this.categorySpendingList});

  @override
  Widget build(BuildContext context) {
    if (categorySpendingList.isEmpty) {
      return const Center(child: EmptyListText(text: 'Ingen udgifter for perioden'));
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: categorySpendingList.length * 60,
        width: MediaQuery.of(context).size.width * 0.8,
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(
              show: false
            ),
            rotationQuarterTurns: 1,
            gridData: FlGridData(show: false),
            barGroups: _buildBarGroups(),
            titlesData: _buildTilesData(context),
            barTouchData: _buildBarTouchData()
        )),
      ),
    );
  }

  FlTitlesData _buildTilesData(BuildContext context) {
    return FlTitlesData(
      topTitles: AxisTitles(),
      leftTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: MediaQuery.of(context).size.width * 0.25,
          showTitles: true,
          getTitlesWidget: (value, meta) => _createTitleWidget(value, meta),
        ),
      ),
    );
  }

  Widget _createTitleWidget(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < categorySpendingList.length) {
      return SideTitleWidget(
        meta: meta,
        child: Text(
          categorySpendingList[index].name,
          textAlign: TextAlign.end,
          style: TTextTheme.mainTheme.labelSmall!.copyWith(
            letterSpacing: 0,
            fontSize: 14
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
        enabled: true,
        handleBuiltInTouches: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipMargin: 16,
          tooltipHorizontalOffset: 2,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            if (groupIndex < 0 || groupIndex >= categorySpendingList.length) {
              return null;
            }

            final item = categorySpendingList[groupIndex];
            return BarTooltipItem(
              item.total.toStringAsFixed(2),
              TTextTheme.mainTheme.labelSmall!.copyWith(
                letterSpacing: 0,
                fontSize: 14
              )
            );
          },
        )
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(categorySpendingList.length, (i) {
      final item = categorySpendingList[i];
      return BarChartGroupData(
        showingTooltipIndicators: [0],
        x: i,
        barRods: [
          BarChartRodData(
            toY: item.total,
            width: 30,
            borderRadius: BorderRadius.zero,
            color: _getColor(i)
          ),
        ],
      );
    });
  }

  Color _getColor(int index) {
    var list = _colorSet;
    int listIndex = index % list.length;
    return list[listIndex];
  }

  final List<Color> _colorSet = [
    Colors.pink.shade100,
    Colors.pink.shade200,
    Colors.pink.shade300
  ];
}
