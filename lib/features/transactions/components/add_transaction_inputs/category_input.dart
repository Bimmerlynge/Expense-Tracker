import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/util/icon_map.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryInput extends ConsumerStatefulWidget {
  const CategoryInput({super.key});

  @override
  ConsumerState<CategoryInput> createState() => _CategoryInputState();
}

class _CategoryInputState extends ConsumerState<CategoryInput> {
  Category getDefault(List<Category> categories) {
    return categories.firstWhere((c) => c.isDefault == true);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryStreamProvider);
    final selectedCategoryValue = ref.watch(selectedCategory);
    final selectedCategoryNotifier = ref.read(selectedCategory.notifier);

    return inputContainer(
      categoriesAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text('Error loading categories: $e'),
        data: (categories) {
          if (categories.isEmpty) {
            return const Text('No categories available');
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              alignment: Alignment.centerLeft,
              dropdownColor: AppColors.primary,
              style: TextStyle(color: AppColors.onPrimary, fontSize: 16),
              isExpanded: true,
              value: selectedCategoryValue ?? getDefault(categories),
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
                  selectedCategoryNotifier.state = newCategory;
                }
              },
            ),
          );
        },
      ),
    );
  }
}
