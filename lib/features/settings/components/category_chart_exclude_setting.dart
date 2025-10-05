import 'dart:math' as math;

import 'package:expense_tracker/features/settings/components/settings_tile.dart';
import 'package:expense_tracker/features/summaries/components/category_filter_chip_field.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/category_chart_screen_controller.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/excluded_categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryChartExcludeSetting extends ConsumerWidget {
  const CategoryChartExcludeSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excludedCategories = ref.watch(excludedCategoriesControllerProvider);
    final spendingList = ref.watch(categoryChartScreenControllerProvider);
    final allCategories = spendingList.value?.getAllCategories() ?? [];

    return SettingsTile(
    icon: Transform.rotate(
      angle: math.pi / 2,
      child: Icon(Icons.bar_chart),
    ),
    label: 'Månedsforbrug kategorier',
    onTap: () => _openDialog(context, allCategories, excludedCategories));
  }

  Future<void> _openDialog(
      BuildContext context, List<String> categories, List<String> excluded) async {
    await showModalBottomSheet(
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