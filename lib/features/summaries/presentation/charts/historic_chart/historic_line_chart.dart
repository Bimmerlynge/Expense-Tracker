import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_spending.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoricLineChart extends StatelessWidget {
  final List<HistoricCategorySpending> lines;
  final List<Color> colors;

  HistoricLineChart({
    super.key,
    required this.lines,
    required this.colors
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          maxX: labels.length - 0.8,
          minX: -0.2,
          lineBarsData: _buildLineBarsData(),
          titlesData: _titlesData(),
          borderData: FlBorderData(
              border: Border(
                bottom: BorderSide(color: AppColors.primaryText)
              ),
              show: true),
          gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: 500,
              show: true
          ),
        )
      ),
    );
  }

  double get maxY {
    double highest = 0;

    for (final line in lines) {
      for (final entry in line.dataSet.entries) {
        if (entry.value.total > highest) {
          highest = entry.value.total;
        }
      }
    }

    return (highest / 500).ceil() * 500;
  }

  List<String> get labels {
    final entries = lines.first.dataSet.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return entries.map((e) {
      final date = e.key;

      return DateFormat("MMM ''yy").format(date).toUpperCase();
    }).toList();
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      rightTitles: AxisTitles(),
      topTitles: AxisTitles(),
      bottomTitles: AxisTitles(sideTitles: _bottomTitles()),
      leftTitles: AxisTitles(sideTitles: leftTitles)
    );
  }

  SideTitles get leftTitles => SideTitles(
    showTitles: true,
    reservedSize: 40,
    interval: 500,
    getTitlesWidget: leftTitleWidgets,
  );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        _formatNumber(value),
        style: TextStyle(fontSize: 10),
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

  SideTitles _bottomTitles() {
    return SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,

        getTitlesWidget: (value, meta) {
          if (value % 1 != 0) {
            return const SizedBox.shrink();
          }

          final index = value.toInt();

          if (index < 0 || index >= labels.length) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              labels[index],
              style: const TextStyle(fontSize: 10),
            ),
          );
        }
    );
  }

  List<LineChartBarData> _buildLineBarsData() {
    return lines.asMap().entries.map((entry) {
      final index = entry.key;
      final line = entry.value;

      final entries = line.dataSet.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      final spots = entries.asMap().entries.map((spotEntry) {
        final data = spotEntry.value;

        return FlSpot(
          spotEntry.key.toDouble(),
          data.value.total,
        );
      }).toList();

      return LineChartBarData(
        spots: spots,
        color: colors[index],
      );
    }).toList();
  }
}
