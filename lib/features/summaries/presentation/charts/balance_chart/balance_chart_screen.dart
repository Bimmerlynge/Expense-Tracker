import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/common/widget/empty_list_text.dart';
import 'package:expense_tracker/features/summaries/components/balance_pie_chart.dart';
import 'package:expense_tracker/features/summaries/domain/balance_total.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/balance_chart/balance_chart_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BalanceChartScreen extends ConsumerStatefulWidget {
  const BalanceChartScreen({super.key});

  @override
  ConsumerState<BalanceChartScreen> createState() => _BalanceChartScreenState();
}

class _BalanceChartScreenState extends ConsumerState<BalanceChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Samlet balance overblik',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        SizedBox(height: 32),
        Expanded(child: _buildPieCharts()),
      ],
    );
  }

  Widget _buildPieCharts() {
    final persons = ref.watch(personListProvider);
    final balanceTotalsAsync = ref.watch(balanceChartScreenControllerProvider);
    final currentUser = ref.watch(currentUserProvider);

    return AsyncValueWidget(
      value: balanceTotalsAsync,
      data: (totals) {
        if (totals.isEmpty) {
          return Center(
            child: EmptyListText(text: 'Ingen transktioner for denne måned'),
          );
        }

        final sortedTotals = List<BalanceTotal>.from(totals)
          ..sort((a, b) {
            if (a.person.id == currentUser.id) return -1;
            if (b.person.id == currentUser.id) return 1;
            return 0;
          });

        return Column(
          mainAxisAlignment: persons.length == 1
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: sortedTotals
              .map(
                (total) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildChart(total),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildChart(BalanceTotal balanceTotal) {
    return BalancePieChart(balanceTotal: balanceTotal);
  }
}
