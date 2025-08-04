import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TotalExpenseChart extends ConsumerStatefulWidget {
  const TotalExpenseChart({super.key});

  @override
  ConsumerState<TotalExpenseChart> createState() => _TotalExpenseChartState();
}

class _TotalExpenseChartState extends ConsumerState<TotalExpenseChart> {
  bool _showPieChart = true;

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionViewModelProvider);

    if (transactionsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Center(
          child: _showPieChart
              ? text24Normal(text: "Pie chart")
              : text24Normal(text: "Bar chart"),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Row(
            children: [
              const Text("Pie"),
              Switch(
                value: !_showPieChart,
                onChanged: (val) {
                  setState(() {
                    _showPieChart = !val;
                  });
                },
              ),
              const Text("Bar"),
            ],
          ),
        ),
      ],
    );
  }
}
