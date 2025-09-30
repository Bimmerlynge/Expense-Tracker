import 'package:expense_tracker/app/repository/category_filter_api.dart';
import 'package:expense_tracker/core/bootstrap/prefences/shared_preferences_provider.dart';
import 'package:expense_tracker/features/summaries/service/category_filter_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryFilterRepoProvider = FutureProvider<CategoryFilterApi>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CategoryFilterRepo(prefs: prefs);
});

class ExcludedCategoriesNotifier extends StateNotifier<List<String>> {
  final CategoryFilterApi repo;

  ExcludedCategoriesNotifier(this.repo) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final excluded = await repo.loadExcluded();
    if (!mounted) return;
    state = excluded;
  }

  Future<void> update(List<String> categories) async {
    state = categories;
    await repo.updateExcluded(categories);
  }
}

final excludedCategoriesProvider =
StateNotifierProvider<ExcludedCategoriesNotifier, List<String>>((ref) {
  final repoAsync = ref.watch(categoryFilterRepoProvider);

  return repoAsync.when(
    data: (repo) => ExcludedCategoriesNotifier(repo),
    loading: () => ExcludedCategoriesNotifier(_FakeRepo()),
    error: (_, _) => ExcludedCategoriesNotifier(_FakeRepo()),
  );
});


class _FakeRepo implements CategoryFilterApi {
  @override
  Future<List<String>> loadExcluded() async => [];
  @override
  Future<void> updateExcluded(List<String> categories) async {}
}

