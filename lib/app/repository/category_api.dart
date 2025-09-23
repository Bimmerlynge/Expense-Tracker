import 'package:expense_tracker/domain/category.dart';

abstract class CategoryApi {
  Future<List<Category>> getHouseholdCategories();
  Stream<List<Category>> getCategoryStream();
}
