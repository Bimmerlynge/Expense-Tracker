import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:expense_tracker/features/summaries/components/historic_chart.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_list.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_color_controller.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_filter_controller.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_mapper.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/historic_category_spending.dart';

class HistoricChartScreen extends ConsumerStatefulWidget {
  const HistoricChartScreen({super.key});

  @override
  ConsumerState<HistoricChartScreen> createState() => _HistoricChartScreenState();
}

class _HistoricChartScreenState extends ConsumerState<HistoricChartScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final controller = ref.read(historicChartScreenControllerProvider.notifier);
      final list = await controller.getList();

      ref
          .read(historicChartFilterControllerProvider.notifier)
          .setData(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(historicChartScreenControllerProvider.notifier);
    final categoriesAsync = ref.watch(historicChartColorControllerProvider);
    final filterController =
    ref.read(historicChartFilterControllerProvider.notifier);
    final filteredList =
      ref.watch(historicChartFilterControllerProvider);

    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Kategorisk historik',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        const SizedBox(height: 16),

        AsyncValueWidget(
          value: categoriesAsync,
          data: (categories) {
            return Flexible(
              child: FutureBuilder<HistoricCategoryList>(
                future: controller.getList(),
                builder: (context, snapshot) {
                  if (filteredList == null) {
                    return const CircularProgressIndicator();
                  }

                  final historicCategoryList = filteredList.getAll();
                  _updateLineChartColors(categories, historicCategoryList);

                  return Column(
                    children: [
                      _buildLegend(historicCategoryList),
                      const SizedBox(height: 32),
                      Expanded(
                        child: HistoricChart(list: filteredList, hiddenCategories: filterController.hiddenCategories),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 50)
      ],
    );
  }

  void _updateLineChartColors(List<Category> categories, List<HistoricCategorySpending> spendingList) {
    for (final item in spendingList) {
      final matched = categories.firstWhere(
            (c) => c.name == item.category.name,
        orElse: () => item.category,
      );
      item.category = matched;
    }
  }

  Widget _buildLegend(List<HistoricCategorySpending> list) {
    final colors = HistoricChartMapper.categories(list);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: colors.map(_legendItem).toList(),
      ),
    );
  }

  Widget _legendItem(Category category) {
    final isHidden = ref
        .watch(historicChartFilterControllerProvider.notifier)
        .isCategoryHidden(category.name);

    return Opacity(
      opacity: isHidden ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: () => _onTapLegend(category),
        onLongPress: () => _onLongPressLegend(category),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              color: category.color ?? Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              category.name,
              style: TTextTheme.mainTheme.labelSmall?.copyWith(
                color: isHidden ? Colors.grey : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapLegend(Category category) {
    ref
        .read(historicChartFilterControllerProvider.notifier)
        .toggleCategory(category.name);
  }

  void _onLongPressLegend(Category category) {
    showDialog(
      context: context,
      builder: (context) {
        Color pickerColor = category.color ?? Colors.grey;
        return PopupWidget(
            popupIcon: Icon(Icons.info_outline_rounded),
            headerTitle: "Vælg farve",
            bodyContent: Theme(
              data: Theme.of(context).copyWith(
                  textTheme: TTextTheme.mainTheme
              ),
              child: ColorPicker(
                labelTypes: [ColorLabelType.rgb],
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  category.color = color;
                },
                enableAlpha: false,
                pickerAreaHeightPercent: 0.7,
              ),
            ),
            onConfirm: () => _onColorChange(category),
            confirmText: "Ændre farve",
        );
      },
    );
  }

  Future<void> _onColorChange(Category updatedCategory) async {
    await ref.read(historicChartScreenControllerProvider.notifier)
        .updateLegendColor(updatedCategory);
  }
}
