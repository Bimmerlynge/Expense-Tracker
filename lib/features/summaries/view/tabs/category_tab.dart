import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/core/bootstrap/prefences/category_filter_providers.dart';
import 'package:expense_tracker/domain/category_spending.dart';
import 'package:expense_tracker/features/summaries/components/category_filter_chip_field.dart';
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
          _createGraphButtons(),
          HorizontalBarChart(categorySpendingList: _applyFilter(spendingList, excludedCategories)),
        ],
      ),
    );
  }

  Widget _createGraphButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _showOnlyCurrentUserCheckbox(),
          IconButton(onPressed: _openFilterDialog, icon: Icon(Icons.rule))
        ],
      ),
    );
  }

  Future<void> _openFilterDialog() async {
    final spendingList = ref.watch(categorySpendingViewModelProvider);
    final excluded = ref.watch(excludedCategoriesProvider);
    final categories = spendingList.map((c) => c.name).toSet().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CategoryFilterChipField(
          categories: categories,
          excluded: excluded,
        );
      },
    );
  }

  Widget _showOnlyCurrentUserCheckbox() {
    final showOnlyMine = ref.watch(showOnlyMineProvider);

    return Row(
      children: [
        Checkbox(
            value: showOnlyMine,
            onChanged: (changed) {
              ref.read(showOnlyMineProvider.notifier).state = changed ?? false;
            }
        ),
        Text('Vis kun mit',
        style: TTextTheme.mainTheme.labelSmall,)
      ],
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
