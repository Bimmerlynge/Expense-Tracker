
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_tab_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'household_categories_provider.g.dart';

@riverpod
List<Category> householdCategories(Ref ref) {
  final categoriesAsync = ref.watch(categoryListTabControllerProvider);

  return categoriesAsync.maybeWhen(
    data: (categories) => categories,
    orElse: () => [],
  );
}