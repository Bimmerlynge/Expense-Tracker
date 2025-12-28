import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/summaries/components/category_filter_chip_field.dart';
import 'package:expense_tracker/features/summaries/components/category_bar_chart.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending_filter_predicates.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/category_chart_screen_controller.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/excluded_categories_controller.dart';
import 'package:expense_tracker/features/summaries/providers/summary_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryChartScreen extends ConsumerStatefulWidget {
  const CategoryChartScreen({super.key});

  @override
  ConsumerState<CategoryChartScreen> createState() =>
      _CategoryChartScreenState();
}

class _CategoryChartScreenState extends ConsumerState<CategoryChartScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Denne måneds forbrug',
            style: Theme.of(context).primaryTextTheme.labelMedium,
          ),
          _createGraphButtons(),
          _buildChart(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final categorySpendingListAsync = ref.watch(
      categoryChartScreenControllerProvider,
    );
    final showOnlyMine = ref.watch(showOnlyMineProvider);
    final currentUser = ref.watch(currentUserProvider);
    final excludedCategories = ref.watch(excludedCategoriesControllerProvider);

    final predicates = <bool Function(Transaction)>[];

    return AsyncValueWidget(
      value: categorySpendingListAsync,
      data: (list) {
        if (excludedCategories.isNotEmpty) {
          predicates.add(excludeCategoriesPredicate(excludedCategories));
        }

        if (showOnlyMine) {
          predicates.add(onlyUserPredicate(currentUser.id));
        }

        return CategoryBarChart(
          categorySpendingList: list.filter(predicates).getAll(),
        );
      },
    );
  }

  Widget _createGraphButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _showOnlyCurrentUserCheckbox(),
          IconButton(onPressed: _openFilterDialog, icon: Icon(Icons.rule)),
        ],
      ),
    );
  }

  Future<void> _openFilterDialog() async {
    final spendingList = ref.watch(categoryChartScreenControllerProvider);
    final excluded = ref.watch(excludedCategoriesControllerProvider);
    final categories = spendingList.value?.getAllCategories() ?? [];

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
          },
        ),
        Text('Vis kun mit', style: TTextTheme.mainTheme.labelSmall),
      ],
    );
  }
}
