import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectWidget<T> extends StatelessWidget {
  final List<T> items;
  final List<T> initialValue;
  final Function(List<T?>) onUpdated;

  const MultiSelectWidget({
    super.key,
    required this.items,
    required this.onUpdated,
    this.initialValue = const []
  });

  @override
  Widget build(BuildContext context) {
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
            MultiSelectChipField<T?>(
              scroll: false,
              items: items
                  .map((i) => MultiSelectItem<T?>(i, i.toString()))
                  .toList(),
              initialValue: initialValue,
              showHeader: false,
              headerColor: AppColors.primary,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.onPrimary.withAlpha(150),
                    width: 1.5,
                  ),
                ),
              ),
              itemBuilder: (MultiSelectItem<T?> item, FormFieldState<List<T?>> state) {
                final isSelected = state.value?.contains(item.value) ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(item.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      final currentValue = state.value ?? [];
                      final newValue = selected
                          ? [...currentValue, item.value]
                          : currentValue.where((v) => v != item.value).toList();

                      state.didChange(newValue);
                      onUpdated(newValue);
                    },
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : AppColors.primaryText,
                    ),
                  ),
                );
              },
            ),
          ]
        ),
      ),
    );
  }
}
