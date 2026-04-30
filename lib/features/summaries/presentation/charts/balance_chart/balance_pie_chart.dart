import 'package:expense_tracker/features/summaries/domain/balance_total.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalancePieChart extends ConsumerStatefulWidget {
  final BalanceTotal balanceTotal;

  const BalancePieChart({super.key, required this.balanceTotal});

  @override
  ConsumerState<BalancePieChart> createState() => _BalancePieChartState();
}

class _BalancePieChartState extends ConsumerState<BalancePieChart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildPieChart(),
        _remainingText()
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        startDegreeOffset: 270,
        centerSpaceRadius: 60,
        sections: _buildSections(),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      PieChartSectionData(
        radius: 20,
        value: widget.balanceTotal.expense,
        color: Colors.red.shade400,
        showTitle: false,
      ),
      PieChartSectionData(
        radius: 20,
        value: (widget.balanceTotal.income - widget.balanceTotal.expense),
        color: Colors.green.shade400,
        showTitle: false,
      ),
    ];
  }

  Widget _remainingText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Rest', style: TextStyle(color: Colors.black54, fontSize: 11)),
        Text(
          '${(widget.balanceTotal.income - widget.balanceTotal.expense).toStringAsFixed(2)} kr.',
          style: TextStyle(
            color: widget.balanceTotal.expense < widget.balanceTotal.income
                ? Colors.green.shade400
                : Colors.red.shade400,
          ),
        ),
      ],
    );
  }
}
