import 'package:expense_tracker/domain/balance_total.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/summaries/providers/summary_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalancePieChart extends ConsumerStatefulWidget {
  const BalancePieChart({super.key, required this.person});

  final Person person;

  @override
  ConsumerState<BalancePieChart> createState() => _BalancePieChartState();
}

class _BalancePieChartState extends ConsumerState<BalancePieChart> {
  BalanceTotal? balanceTotal;

  @override
  Widget build(BuildContext context) {
    ref.watch(balanceTotalViewModelProvider);
    late final viewModel = ref.read(balanceTotalViewModelProvider.notifier);
    balanceTotal = viewModel.getBalanceTotal(widget.person);

    return SizedBox(
      height: 220,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.person.name,
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
      children: [_buildPieChart(), _buildChartTitle(), _buildChartLegend()],
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
        value: balanceTotal?.income,
        color: Colors.green.shade400,
        showTitle: false,
      ),
      PieChartSectionData(
        value: balanceTotal?.expense,
        color: Colors.red.shade400,
        showTitle: false,
      ),
    ];
  }

  Widget _buildChartTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${balanceTotal?.income.toStringAsFixed(2)} kr.',
          style: TextStyle(color: Colors.green.shade400),
        ),
        Text(
          '${balanceTotal?.expense.toStringAsFixed(2)} kr.',
          style: TextStyle(color: Colors.red.shade400),
        ),
      ],
    );
  }

  Widget _buildChartLegend() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Icon(Icons.square, color: Colors.green.shade400),
              Text(
                'Indkomst',
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.square, color: Colors.red.shade400),
              Text(
                'Forbrug',
                style: Theme.of(context).primaryTextTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
