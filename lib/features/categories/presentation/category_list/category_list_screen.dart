import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_screen_controller.dart';
import 'package:expense_tracker/features/categories/presentation/create_category/create_category_popup.dart';
import 'package:expense_tracker/features/categories/widgets/category_list_table.dart';
import 'package:expense_tracker/features/categories/widgets/delete_category_dialog.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/common/widget/empty_list_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryListScreen extends ConsumerStatefulWidget {
  const CategoryListScreen({super.key});

  @override
  ConsumerState<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends ConsumerState<CategoryListScreen> {

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListScreenControllerProvider);

    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Kategorier i husstanden',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        SizedBox(height: 8),
        OutlinedButton(
            onPressed: _showCreateCategoryPopup,
            child: Text('Opret kategori')
        ),
        SizedBox(height: 8),
        Expanded(
          child: AsyncValueWidget(
            value: categoriesAsync,
            data: (categories) => _buildList(categories)
          )
        )
      ],
    );
  }

  void _showCreateCategoryPopup() async {
    await showDialog(
        context: context,
        builder: (context) {
          return CreateCategoryPopup();
        }
    );
  }

  Widget _buildList(List<Category> categories) {
    if (categories.isEmpty) {
      return Center(child: EmptyListText(text: 'Ingen kategorier defineret'));
    }

    return CategoryListTable(
        categories: categories,
        onDefaultChange: _toggleDefault,
        onDeleteCategory: _handleOnDelete,
    );
  }

  Future<void> _handleOnDelete(Category category) async {
    if (category.isFixedExpense()) {
      ToastService.showErrorToast('Niks pille Morth Fuckes!!');
      return;
    }

    final shouldDelete = await _showDeleteConfirmationDialog(category);
    if (!shouldDelete) return;

    _deleteTransaction(category);
  }

  Future<void> _deleteTransaction(Category category) async {
    try {
      await ref.read(categoryListScreenControllerProvider.notifier)
          .removeCategory(category.id!);
      ToastService.showSuccessToast("Kategori blev slettet!");
    } catch (e) {
      ToastService.showErrorToast("Fejl: Kunne ikke slette kategori.");
    }
  }

  Future<bool> _showDeleteConfirmationDialog(Category category) async {
    return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => DeleteCategoryDialog(category: category)
    ) ?? false;
  }

  Future<void> _toggleDefault(Category category) async {
    await ref.read(categoryListScreenControllerProvider.notifier)
        .updateDefaultCategory(category);
  }
}
