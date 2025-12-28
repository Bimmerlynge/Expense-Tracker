import 'package:expense_tracker/features/common/application/local_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'excluded_categories_controller.g.dart';

@riverpod
class ExcludedCategoriesController extends _$ExcludedCategoriesController {
  @override
  List<String> build() {
    final service = ref.read(localStorageService);
    return service.getExcludedCategories();
  }

  Future<void> updateExcluded(List<String> excludedList) async {
    final service = ref.read(localStorageService);
    await service.updateExcludedCategories(excludedList);
    state = service.getExcludedCategories();
  }
}
