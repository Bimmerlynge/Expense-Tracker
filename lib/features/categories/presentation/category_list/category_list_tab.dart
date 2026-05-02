import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_tab_controller.dart';
import 'package:expense_tracker/features/categories/widgets/delete_category_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/household_categories_provider.dart';

class CategoryListTab extends ConsumerStatefulWidget {
  const CategoryListTab({super.key});

  @override
  ConsumerState<CategoryListTab> createState() => _CategoryListTabState();
}

class _CategoryListTabState extends ConsumerState<CategoryListTab> {

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(householdCategoriesProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        _header(),
        Expanded(child: _list(categories))
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kategori', style: TextStyle(color: AppColors.primary.withAlpha(200))),
              Text('Standard udgift', style: TextStyle(color: AppColors.primary.withAlpha(200))),
            ],
          ),
          Divider(color: AppColors.primaryText.withAlpha(50)),
        ],
      ),
    );
  }

  Widget _list(List<Category> categories) {
    if (categories.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.separated(
        padding: const EdgeInsets.only(top: 0, bottom: 12),
        itemCount: categories.length,
        separatorBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(color: AppColors.primaryText.withAlpha(30)),
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _listItem(category);
        }, 
    );
  }
  
  Widget _listItem(Category category) {
    return Dismissible(
      key: ValueKey(category.id),
      confirmDismiss: (_) async {
        return await _handleOnDelete(category);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            _icon(category),
            SizedBox(width: 12),
            Text(category.name, style: TextStyle(color: AppColors.primary)),
            Spacer(),
            Toggle(
                activeBackgroundColor: AppColors.primary,
                activeAccentColor: AppColors.primary,
                accentColor: AppColors.primary,
                value: category.isDefault ?? false,
                onToggled: (val) {
                  _toggleDefault(category);
                }
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _handleOnDelete(Category category) async {
    if (category.isFixedExpense()) {
      ToastService.showErrorToast('Niks pille Morth Fuckes!!');
      return false;
    }

    return await _showDeleteConfirmationDialog(category);
  }

  Future<bool> _showDeleteConfirmationDialog(Category category) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DeleteCategoryModal(
        category: category,
        onDelete: () async {
          await _deleteCategory(category);

          if(mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );

    return result ?? false;
  }
  Future<bool> _deleteCategory(Category category) async {
    try {
      await ref
          .read(categoryListTabControllerProvider.notifier)
          .removeCategory(category.id!);
      ToastService.showSuccessToast("Kategori blev slettet!");
      return true;
    } catch (e) {
      ToastService.showErrorToast("Fejl: Kunne ikke slette kategori.");
      return false;
    }
  }

  Widget _icon(Category category) {
    return InkWell(
      onTap: () => ToastService.showInfoToast('Ikke implementeret endnu'),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.whiter,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.favorite_border, color: AppColors.primary),
      ),
    );
  }

  Future<void> _toggleDefault(Category category) async {
    await ref
        .read(categoryListTabControllerProvider.notifier)
        .updateDefaultCategory(category);
  }
}
