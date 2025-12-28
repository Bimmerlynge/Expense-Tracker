import 'dart:async';

import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/application/category_service.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_list_screen_controller.g.dart';

@riverpod
class CategoryListScreenController extends _$CategoryListScreenController {
  late final StreamSubscription<List<Category>> _subscription;

  @override
  FutureOr<List<Category>> build() {
    state = AsyncLoading();

    final service = ref.watch(categoryServiceProvider);
    final stream = service.getHouseholdCategoriesStream();

    _subscription = stream.listen(
      (categories) => state = AsyncData(categories),
      onError: (error, stack) => state = AsyncError(error, stack),
    );

    ref.onDispose(() => _subscription.cancel());

    return stream.first;
  }

  Future<void> updateDefaultCategory(Category category) async {
    await ref.read(categoryServiceProvider).updateDefaultCategory(category);
    ref.read(selectedCategoryProvider.notifier).state = category;
  }

  Future<bool> removeCategory(String categoryId) async {
    return await ref.read(categoryServiceProvider).removeCategory(categoryId);
  }
}
