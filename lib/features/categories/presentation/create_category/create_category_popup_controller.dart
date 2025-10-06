import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/application/category_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_category_popup_controller.g.dart';

@riverpod
class CreateCategoryPopupController extends _$CreateCategoryPopupController {

  @override
  Category build() {
    return Category(name: '', isDefault: false);
  }

  Future<bool> createCategory() async {
    return await ref.read(categoryServiceProvider).createCategory(state);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }
}