import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryFilterPrefs {
 final List<String> _excludedCategories = ['Faste udgifter'];

  Future<void> loadExcluded(WidgetRef ref) async {
    final excludedCategoryNotifier = ref.read(excludedCategoriesProvider.notifier);
    await Future.delayed(Duration(milliseconds: 50));
    excludedCategoryNotifier.state = _excludedCategories;
  }
}

final categoryFilterPrefsProvider = Provider<CategoryFilterPrefs>((ref) {
  return CategoryFilterPrefs();
});

final excludedCategoriesProvider = StateProvider<List<String>>((ref) => []);