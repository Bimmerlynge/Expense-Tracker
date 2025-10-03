import 'package:expense_tracker/core/bootstrap/prefences/shared_preferences_provider.dart';
import 'package:expense_tracker/features/common/data/local_storage_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsRepositoryProvider = Provider<SharedPrefsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPrefsRepository(prefs: prefs);
});

class SharedPrefsRepository implements LocalStorageRepository {
  final SharedPreferences prefs;

  static const String _collapsedFixedExpensesKey = 'collapsed_fixed_expenses';

  SharedPrefsRepository({required this.prefs});

  @override
  List<String> loadCollapsedFixedExpenses() {
    return prefs.getStringList(_collapsedFixedExpensesKey) ?? [];
  }

  @override
  Future<void> updateCollapsedFixedExpenses(List<String> expenseIds) async {
    await prefs.setStringList(_collapsedFixedExpensesKey, expenseIds);
  }
}