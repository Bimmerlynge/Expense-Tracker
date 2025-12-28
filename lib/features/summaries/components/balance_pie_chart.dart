import 'package:expense_tracker/app/config/theme/text_theme.dart';
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
    return SizedBox(
      height: 220,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.balanceTotal.person.name,
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          SizedBox(height: 24),
          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildPieChart(),
        _buildChartTitle(),
        _buildChartLegend(),
        _buildIncomeLegend(),
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
        value: widget.balanceTotal.expense,
        color: Colors.red.shade400,
        showTitle: false,
      ),
      PieChartSectionData(
        value: (widget.balanceTotal.income - widget.balanceTotal.expense),
        color: Colors.green.shade400,
        showTitle: false,
      ),
    ];
  }

  Widget _buildChartTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Rest', style: TTextTheme.mainTheme.labelSmall),
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

  Widget _buildIncomeLegend() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'Indkomst',
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
              Text(
                widget.balanceTotal.income.toStringAsFixed(2),
                textAlign: TextAlign.end,
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    'Forbrug',
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                  Text(
                    widget.balanceTotal.expense.toStringAsFixed(2),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
