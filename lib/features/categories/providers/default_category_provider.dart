import 'package:expense_tracker/domain/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../presentation/category_list/category_list_tab_controller.dart';

part 'default_category_provider.g.dart';

@riverpod
Category defaultCategory(Ref ref) {
  final categoriesAsync = ref.watch(categoryListTabControllerProvider);

  return categoriesAsync.maybeWhen(
    data: (categories) => categories.firstWhere(
          (c) => c.isDefault == true,
      orElse: () => categories.first,
    ),
    orElse: () => Category(name: "Hobby"),
  );
}