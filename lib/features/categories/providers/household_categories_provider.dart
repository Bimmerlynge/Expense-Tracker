
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'household_categories_provider.g.dart';

@riverpod
List<Category> householdCategories(Ref ref) {
  final categoriesAsync = ref.watch(categoryListScreenControllerProvider);

  return categoriesAsync.maybeWhen(
    data: (categories) => categories,
    orElse: () => [],
  );
}