import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_list.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_mapper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HistoricChart extends StatelessWidget {
  final HistoricCategoryList list;
  final Set<String> hiddenCategories;
  final bool showFullYear = false;

  const HistoricChart({
    super.key,
    required this.list,
    required this.hiddenCategories
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: LineChart(
          lineChartData
      ),
    );
  }

  LineChartData get lineChartData => LineChartData(
    maxY: ((list.getMaxAmountSpend(hiddenCategories) + 500) / 500).floor() * 500,
    minY: 0,
    minX: 1,
    // maxX: showFullYear ? 12 : 6,
    lineBarsData: HistoricChartMapper.toLineChartDataList(list, hiddenCategories),
    gridData: const FlGridData(show: false),
    titlesData: titlesData
  );

  FlTitlesData get titlesData => FlTitlesData(
    leftTitles: AxisTitles(
      sideTitles: leftTitles
    ),
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles
    ),
    topTitles: AxisTitles(),
    rightTitles: AxisTitles()
  );

  SideTitles get leftTitles => SideTitles(
    showTitles: true,
    reservedSize: 50,
    getTitlesWidget: leftTitleWidgets,
  );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        _formatNumber(value),
        style: TTextTheme.mainTheme.labelSmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    } else {
      return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
    }
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final date = HistoricChartMapper.xToDateMap[value];
    if (date == null) return const SizedBox.shrink();

    final month = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'][date.month - 1];

    return SideTitleWidget(
      meta: meta,
      space: 8, // extra space between tick and label
      child: Transform.translate(
        offset: const Offset(0, 20),
        child: Transform.rotate(
          angle: -math.pi / 2, // ~ -34° in radians (negative = tilt up to the left)
          alignment: Alignment.center,
          child: Text(
            '$month ${date.year.toString().substring(2)}',
            style: TTextTheme.mainTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
