import 'package:expense_tracker/features/common/data/shared_prefs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageService = Provider<LocalStorageService>((ref) {
  return LocalStorageService(
      prefsRepository: ref.read(sharedPrefsRepositoryProvider)
  );
});

class LocalStorageService {
  final SharedPrefsRepository prefsRepository;

  LocalStorageService({required this.prefsRepository});

  List<String> getExcludedCategories() {
    return prefsRepository.loadExcludedCategories();
  }

  Future<void> updateExcludedCategories(List<String> categories) async {
    await prefsRepository.updateExcludedCategories(categories);
  }

  List<String> getCollapsedFixedExpenses() {
    return prefsRepository.loadCollapsedFixedExpenses();
  }

  Future<void> toggleCollapsedFixedExpense(String expenseId) async {
    final collapsed = prefsRepository.loadCollapsedFixedExpenses();

    if (collapsed.contains(expenseId)) {
      collapsed.remove(expenseId);
    } else {
      collapsed.add(expenseId);
    }

    await prefsRepository.updateCollapsedFixedExpenses(collapsed);
  }
}