import 'package:expense_tracker/domain/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../presentation/category_list/category_list_screen_controller.dart';

part 'default_category_provider.g.dart';

@riverpod
Category defaultCategory(Ref ref) {
  final categoriesAsync = ref.watch(categoryListScreenControllerProvider);

  return categoriesAsync.maybeWhen(
    data: (categories) => categories.firstWhere(
          (c) => c.isDefault == true,
      orElse: () => categories.first,
    ),
    orElse: () => Category(name: "Hobby"),
  );
}