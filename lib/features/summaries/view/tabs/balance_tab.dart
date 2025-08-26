import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/summaries/components/balance_pie_chart.dart';
import 'package:expense_tracker/features/summaries/providers/summary_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceTab extends ConsumerStatefulWidget {
  const BalanceTab({super.key});

  @override
  ConsumerState<BalanceTab> createState() => _BalanceTabState();
}

class _BalanceTabState extends ConsumerState<BalanceTab> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text('Samlet balance overblik', style: Theme.of(context).primaryTextTheme.labelMedium,),
        SizedBox(height: 32,),
        Expanded(child: _buildPieCharts())
      ],
    );
  }

  Widget _buildPieCharts() {
    final persons = ref.watch(personListProvider);

    return Column(
      mainAxisAlignment: persons.length == 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: persons.map((person) => Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: _buildChart(person),
      )).toList()
    );

  }

  Widget _buildChart(Person person) {
    return BalancePieChart(person: person);
  }
}
