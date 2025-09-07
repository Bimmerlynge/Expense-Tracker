import 'package:expense_tracker/core/bootstrap/prefences/category_filter_pref.dart';
import 'package:expense_tracker/domain/category_spending.dart';
import 'package:expense_tracker/features/summaries/components/horizontal_bar_chart.dart';
import 'package:expense_tracker/features/summaries/providers/summary_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTab extends ConsumerStatefulWidget {
  const CategoryTab({super.key});

  @override
  ConsumerState<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends ConsumerState<CategoryTab> {
  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final spendingList = ref.watch(categorySpendingViewModelProvider);
    final viewModel = ref.read(categorySpendingViewModelProvider.notifier);
    final excludedCategories = ref.watch(excludedCategoriesProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Denne måneds forbrug',
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          SizedBox(height: 8),
          HorizontalBarChart(categorySpendingList: _applyFilter(spendingList, excludedCategories)),
        ],
      ),
    );
  }

  List<CategorySpending> _applyFilter(
    List<CategorySpending> list,
    List<String> excludedCategories,
  ) {
    return list
        .where((c) => !excludedCategories.contains(c.name))
        .toList();
  }
}
