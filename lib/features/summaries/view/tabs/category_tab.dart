import 'package:expense_tracker/features/summaries/components/horizontal_bar_chart.dart';
import 'package:expense_tracker/features/summaries/providers/summary_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTab extends ConsumerWidget {
  const CategoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final spendingList = ref.watch(categorySpendingViewModelProvider);
    final viewModel = ref.read(categorySpendingViewModelProvider.notifier);



    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            SizedBox(height: 16,),
            Text(
              'Denne måneds forbrug',
              style: Theme.of(context).primaryTextTheme.labelMedium,
            ),
            HorizontalBarChart(
              categorySpendingList: spendingList
            )
          ],
        ),
      ),
    );
  }
}
