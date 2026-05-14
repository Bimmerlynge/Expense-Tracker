import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/t_dropdown.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/design_system/primitives/white_box.dart';
import 'package:expense_tracker/extensions/responsive_extensions.dart';
import 'package:expense_tracker/features/common/application/local_storage_service.dart';
import 'package:expense_tracker/features/summaries/domain/graph_range.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_line_chart.dart';
import 'package:expense_tracker/features/summaries/providers/historic_chart_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class HistoricChartTab extends ConsumerStatefulWidget {
  const HistoricChartTab({super.key});

  @override
  ConsumerState<HistoricChartTab> createState() => _HistoricChartTabState();
}

class _HistoricChartTabState extends ConsumerState<HistoricChartTab> {

  final colors = [
    const Color(0xFF2962FF), // Blue
    const Color(0xFFFF6D00), // Orange
    const Color(0xFF00C853), // Green
    const Color(0xFFD500F9), // Purple
    const Color(0xFFFF1744), // Red
    const Color(0xFF00B8D4), // Cyan
    const Color(0xFFFFAB00), // Amber
    const Color(0xFF6200EA), // Deep Purple
    const Color(0xFF1DE9B6), // Teal
    const Color(0xFFAEEA00), // Lime
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          _actions(),
          SizedBox(height: 8),
          Expanded(child: _body()),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _actions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final small = context.isSmallPhone;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 50,
                      child: _onlyMine()),
                  SizedBox(width: 8),
                  Expanded(
                      flex: 50,
                      child: _rangeSelector()),
                ],
              ),
              SizedBox(height: 6,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Sammenlign kategorier',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: _compareCategoriesDropdown()),
                  SizedBox(width: 24,),
                  ElevatedButton(
                    onPressed: () {
                      ToastService.showInfoToast("Ikke implementeret");
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.whiter,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.secondary,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text("Vælg preset"),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _compareCategoriesDropdown() {
    final selectedList = ref.watch(selectListProvider);

    String buildDisplayText(
        List<String> items, {
          int maxLength = 20,
        }) {
      if (items.isEmpty) {
        return "Select Categories";
      }

      String text = "";
      int shownCount = 0;

      for (final item in items) {
        final candidate = text.isEmpty ? item : "$text, $item";

        if (candidate.length > maxLength) {
          break;
        }

        text = candidate;
        shownCount++;
      }

      final remaining = items.length - shownCount;

      if (remaining > 0) {
        text += " +$remaining";
      }

      return text;
    }

    final displayText = buildDisplayText(selectedList);

    return GestureDetector(
      onTap: _openMultiSelect,
      child: WhiteBox(
          child: SizedBox(
            height: 35,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Center(child: Text(displayText, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                  Spacer(),
                  Icon(Icons.arrow_drop_down, color: Colors.black87,)
                ],
              ),
            ),
          )
      ),
    );
  }

  void _openMultiSelect() async {
    final all = ref.watch(historicListProvider);
    final selected = ref.watch(selectListProvider);

    await showDialog(
        context: context,
        builder: (ctx) {
          return MultiSelectDialog<String>(
            onConfirm: _updateSelectedList,
            title: Center(child: Text("Valgte kategorier", style: TextStyle(color: Colors.black87),)),
            height: MediaQuery.of(context).size.height * 0.5,
              items: all.getAll().map(
                      (e) {
                    return MultiSelectItem(e.category.name, e.category.name);
                  }
              ).toList(),
              initialValue: selected
          );
        }
    );
  }

  Future<void> _updateSelectedList(List<String> selectedCategories) async {
    try {
      await ref.read(localStorageService).updateSelectedHistoricCategories(selectedCategories);
      ref.read(selectListProvider.notifier).state = selectedCategories;
    } catch (e) {
      ToastService.showErrorToast("Kunne ikke opdate listen");
    }
  }

  Widget _onlyMine() {
    return Row(
      children: [
        Toggle(
            activeAccentColor: AppColors.primary,
            backgroundColor: AppColors.primaryText,
            accentColor: AppColors.primaryText,
            value: ref.watch(showOnlyMyHistoryProvider),
            onToggled: (value) {
              ref.read(showOnlyMyHistoryProvider.notifier).state = value;
            }
        ),
        SizedBox(width: 4),
        Text('Vis kun min', style: TextStyle(color: AppColors.containerOnPrimary))
      ],
    );
  }

  Widget _rangeSelector() {
    return WhiteBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.date_range, color: AppColors.primary),
            Expanded(
              child: TDropdown(
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: [
                    GraphRange.sixMonths,
                    GraphRange.oneYear
                  ],
                  value: ref.watch(graphRangeHistoryProvider),
                  onChanged: (value) {
                    ToastService.showInfoToast("Ikke implementeret endnu");
                  },
                  label: (graphRange) => graphRange.label
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    final list = ref.watch(filteredHistoricListProvider);

    if (list.isEmpty) return Center(child: CircularProgressIndicator());

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 60,
            child: HistoricLineChart(lines: list, colors: colors,)),
        Flexible(
            fit: FlexFit.loose,
            flex: 40,
            child: _selectedList()),
      ],
    );
  }

  Widget testHeight() {
    final list = ref.watch(filteredHistoricListProvider);

    if (list.isEmpty) return Center(child: CircularProgressIndicator());

    return LayoutBuilder(
      builder: (context, constraints) {

        final chartHeight = constraints.maxHeight * 0.42;

        return Column(
          children: [
            SizedBox(
              height: chartHeight,
              child: HistoricLineChart(
                lines: list,
                colors: colors,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedList(),
            ),
          ],
        );
      },
    );
  }

  Widget _selectedList() {
    final list = ref.watch(filteredHistoricListProvider);

    return WhiteBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
            itemCount: list.length,
            separatorBuilder: (_,_) => Divider(),
            itemBuilder: (context, index) {
              final categorySpending = list[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colors[index].withAlpha(40),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.favorite_border, color: colors[index])),
                    SizedBox(width: 12),
                    Icon(Icons.circle, size: 10, color: colors[index]),
                    SizedBox(width: 8,),
                    Text(categorySpending.category.name, style: TextStyle(fontSize: 12),),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Total: ${categorySpending.getTotal().toStringAsFixed(2)} kr", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        Text("Avg: ${categorySpending.getAverage().toStringAsFixed(2)} kr", style: TextStyle(fontSize: 11))
                      ],
                    )
                  ],
                ),
              );
            },
        ),
      ),
    );
  }
}
