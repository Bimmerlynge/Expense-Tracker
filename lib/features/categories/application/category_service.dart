import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/data/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryServiceProvider = Provider<CategoryService>((ref) {
  return CategoryService(
      categoryRepository: ref.read(categoryRepositoryProvider)
  );
});

class CategoryService {
  final CategoryRepository categoryRepository;

  CategoryService({required this.categoryRepository});

  Stream<List<Category>> getHouseholdCategoriesStream() {
    return categoryRepository.getCategoriesStream();
  }

  Future<void> updateDefaultCategory(Category category) async {
    await categoryRepository.updateDefaultCategory(category);
  }

  Future<bool> createCategory(Category newCategory) async {
    return await categoryRepository.createCategory(newCategory);
  }

  Future<bool> removeCategory(String categoryId) async {
    return await categoryRepository.removeCategory(categoryId);
  }
}