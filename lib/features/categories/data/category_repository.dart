import 'package:expense_tracker/domain/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  throw UnimplementedError("CategoryRepository must be overridden");
});

abstract class CategoryRepository {
  Stream<List<Category>> getCategoriesStream();
  Future<bool> createCategory(Category category);
  Future<bool> removeCategory(String categoryId);
  Future<void> updateDefaultCategory(Category category);
  Future<void> updateCategoryColor(Category category);
}
