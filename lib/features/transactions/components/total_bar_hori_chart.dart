import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<CategorySpending> categorySpendingList;

  const HorizontalBarChart({super.key, required this.categorySpendingList});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: BarChart(
        BarChartData(

    )
    ),
    );
  }
}
