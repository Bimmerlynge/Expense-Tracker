import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/excluded_categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';

class CategoryFilterChipField extends ConsumerWidget {
  final List<String> categories;
  final List<String> excluded;

  const CategoryFilterChipField({
    super.key,
    required this.categories,
    required this.excluded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Center(
                child: Text(
                  'Viste kategorier',
                  style: TTextTheme.mainTheme.labelLarge,
                ),
              ),
            ),
            MultiSelectChipField<String?>(
              onSaved: (_) {},
              initialValue: categories
                  .where((c) => !excluded.contains(c))
                  .toList(),
              items: categories
                  .map((c) => MultiSelectItem<String?>(c, c))
                  .toList(),
              scroll: false,
              showHeader: false,
              height: 220,
              headerColor: AppColors.primary,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.onPrimary.withAlpha(150),
                    width: 1.5,
                  ),
                ),
              ),
              itemBuilder:
                  (
                    MultiSelectItem<String?> item,
                    FormFieldState<List<String?>> state,
                  ) {
                    final isSelected =
                        state.value?.contains(item.value) ?? true;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(item.value ?? ''),
                        selected: isSelected,
                        onSelected: (selected) {
                          final currentValue = state.value ?? [];
                          List<String?> newValue;
                          if (selected) {
                            newValue = [...currentValue, item.value];
                          } else {
                            newValue = currentValue
                                .where((v) => v != item.value)
                                .toList();
                          }

                          state.didChange(newValue);

                          final allSelected = newValue
                              .whereType<String>()
                              .toList();
                          final newExcluded = categories
                              .where((c) => !allSelected.contains(c))
                              .toList();
                          ref
                              .read(
                                excludedCategoriesControllerProvider.notifier,
                              )
                              .updateExcluded(newExcluded);
                        },
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : AppColors.primaryText,
                        ),
                      ),
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }
}
