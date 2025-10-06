import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
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
    required this.onDeleteCategory
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
          Text(
            'Kategori',
            style: TTextTheme.mainTheme.labelMedium,
          ),
          Text(
            'Default udgift',
            style: TTextTheme.mainTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildList() {
    return categories.map((category) {
      return GestureDetector(
        onLongPress: ()  {
          onDeleteCategory(category);
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
              Switch(
                value: category.isDefault ?? false,
                onChanged: (v) {
                  if (v) onDefaultChange(category);
                },
                inactiveThumbColor: AppColors.onPrimary.withAlpha(150),
                inactiveTrackColor: AppColors.secondary.withAlpha(150),
                trackOutlineColor: WidgetStateProperty.all(
                    AppColors.onPrimary.withAlpha(150)),
                activeTrackColor: AppColors.onPrimary.withAlpha(190),
                thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color.fromARGB(255, 206, 206, 206);
                  }
                  return AppColors.onPrimary;
                }),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _onLongPress(Category category, BuildContext context) async {

  }
}