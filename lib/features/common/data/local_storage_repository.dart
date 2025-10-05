abstract class LocalStorageRepository {
  List<String> loadCollapsedFixedExpenses();
  Future<void> updateCollapsedFixedExpenses(List<String> expenseIds);
  List<String> loadExcludedCategories();
  Future<void> updateExcludedCategories(List<String> categories);
}