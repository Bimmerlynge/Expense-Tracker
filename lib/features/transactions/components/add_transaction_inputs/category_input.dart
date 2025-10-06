import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_screen_controller.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryInput extends ConsumerStatefulWidget {
  const CategoryInput({super.key});

  @override
  ConsumerState<CategoryInput> createState() => _CategoryInputState();
}

class _CategoryInputState extends ConsumerState<CategoryInput> {

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListScreenControllerProvider);

    return inputContainer(
      AsyncValueWidget(
          value: categoriesAsync,
          data: (categories) => _buildDropdown(categories)
      ),
    );
  }

  Category _getDefaultCategory(List<Category> categories) {
    return categories.firstWhere(
            (c) => c.isDefault == true,
        orElse: () => categories.first
    );
  }

  Widget _buildDropdown(List<Category> categories) {
    if (categories.isEmpty) {
      return const Text('No categories available');
    }

    final selectedCategory = ref.watch(selectedCategoryProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultCategory = _getDefaultCategory(categories);

      if (selectedCategory == null) {
        ref.read(selectedCategoryProvider.notifier)
            .state = defaultCategory;
      }
    });

    if (selectedCategory == null) {
      return const SizedBox.shrink();
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<Category>(
        alignment: Alignment.centerLeft,
        dropdownColor: AppColors.primary,
        style: TextStyle(color: AppColors.onPrimary, fontSize: 16),
        isExpanded: true,
        value: selectedCategory,
        items: categories.map((category) {
          return DropdownMenuItem<Category>(
            value: category,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(category.name)],
            ),
          );
        }).toList(),
        onChanged: (newCategory) {
          if (newCategory != null) {
            ref.read(selectedCategoryProvider.notifier).state = newCategory;
          }
        },
      ),
    );
  }
}
