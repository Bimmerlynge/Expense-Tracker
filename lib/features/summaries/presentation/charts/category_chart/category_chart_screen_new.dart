import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/components/actions_row.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/components/category_bar_chart_new.dart';
import 'package:expense_tracker/features/summaries/components/category_filter_chip_field.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending_filter_predicates.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/category_chart_screen_controller.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/excluded_categories_controller.dart';
import 'package:expense_tracker/features/summaries/providers/category_spending_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/summary_providers.dart' show showOnlyMineProvider;

class CategoryChartScreenNew extends ConsumerStatefulWidget {
  const CategoryChartScreenNew({super.key});

  @override
  ConsumerState<CategoryChartScreenNew> createState() => _CategoryChartScreenNewState();
}

class _CategoryChartScreenNewState extends ConsumerState<CategoryChartScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          _actions(),
          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  Widget _actions() {
    return ActionsRow(
      alignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Toggle(
              activeAccentColor: AppColors.primary,
              backgroundColor: AppColors.primaryText,
              accentColor: AppColors.primaryText,
              value: ref.watch(showOnlyMineProvider),
              onToggled: (val) {
                ref.read(showOnlyMineProvider.notifier).state = val;
              },
            ),
            Text('Vis kun mit', style: TextStyle(color: AppColors.containerOnPrimary)),
          ],
        ),
        IconButton(onPressed: _openFilterDialog, icon: Icon(Icons.rule, color: AppColors.primary,)),
      ],
    );
  }

  Widget _buildChart() {
    final categorySpendingList = ref.watch(categorySpendingListProvider);
    final showOnlyMine = ref.watch(showOnlyMineProvider);
    final currentUser = ref.watch(currentUserProvider);
    final excludedCategories = ref.watch(excludedCategoriesControllerProvider);

    final predicates = <bool Function(Transaction)>[];

    if (excludedCategories.isNotEmpty) {
      predicates.add(excludeCategoriesPredicate(excludedCategories));
    }

    if (showOnlyMine) {
      predicates.add(onlyUserPredicate(currentUser.id));
    }

    return CategoryBarChartNew(
      items: categorySpendingList.filter(predicates).getAll(),
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
}
