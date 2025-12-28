import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:flutter/material.dart';

class CategoryListTable extends StatelessWidget {
  final List<Category> categories;
  final ValueChanged<Category> onDefaultChange;
  final Future<void> Function(Category) onDeleteCategory;

  const CategoryListTable({
    super.key,
    required this.categories,
    required this.onDefaultChange,
    required this.onDeleteCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Colors.grey),
          ..._buildList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Kategori', style: TTextTheme.mainTheme.labelMedium),
          Text('Default udgift', style: TTextTheme.mainTheme.labelMedium),
        ],
      ),
    );
  }

  List<Widget> _buildList() {
    return categories.map((category) {
      return Dismissible(
        key: ValueKey(category.id),
        confirmDismiss: (_) async {
          await onDeleteCategory(category);
          return false;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.primarySecondText.withAlpha(100),
              ),
            ),
            color: category.isDefault == true
                ? AppColors.secondary.withAlpha(100)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: TTextTheme.mainTheme.labelMedium!.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              Toggle(
                value: category.isDefault ?? false,
                onToggled: (val) {
                  if (val) onDefaultChange(category);
                },
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
