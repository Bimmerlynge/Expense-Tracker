import 'package:expense_tracker/app/config/theme/text_theme.dart';
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
      children: [
        _buildPieChart(),
        _buildChartTitle(),
        _buildChartLegend(),
        _buildIncomeLegend()
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
        value: balanceTotal!.expense,
        color: Colors.red.shade400,
        showTitle: false,
      ),
      PieChartSectionData(
        value: (balanceTotal!.income - balanceTotal!.expense),
        color: Colors.green.shade400,
        showTitle: false,
      ),

    ];
  }

  Widget _buildChartTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Rest',
          style: TTextTheme.mainTheme.labelSmall,
        ),
        Text(
          '${(balanceTotal!.income - balanceTotal!.expense).toStringAsFixed(2)} kr.',
          style: TextStyle(color: balanceTotal!.expense < balanceTotal!.income ?
          Colors.green.shade400 : Colors.red.shade400),
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
              Text(balanceTotal!.income.toStringAsFixed(2),
                textAlign: TextAlign.end,
                style: Theme.of(context).primaryTextTheme.labelSmall,
              )
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
                  Text(balanceTotal!.expense.toStringAsFixed(2),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).primaryTextTheme.labelSmall,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
