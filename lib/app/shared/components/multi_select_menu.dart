import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';

class MultiSelectMenu<T> extends ConsumerWidget {
  final List<MultiSelectItem<T>> items;
  final List<T> selected;
  final ValueChanged<List<T>> onChanged;
  final String label;

  const MultiSelectMenu({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.label = 'Filter',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(child: _buildButton(context));
  }

  Widget _buildButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showMultiSelectDialog(context),
      child: Text(label),
    );
  }

  Future<void> _showMultiSelectDialog(BuildContext context) async {
    final selectedValues = await showDialog<List<T>>(
      context: context,
      builder: (context) => MultiSelectDialog<T>(
        items: items,
        initialValue: selected,
        itemsTextStyle: TTextTheme.mainTheme.labelMedium,
        selectedItemsTextStyle: TTextTheme.mainTheme.labelMedium,
        checkColor: AppColors.onPrimary,
      ),
    );

    if (selectedValues != null) {
      onChanged(selectedValues);
    }
  }
}
