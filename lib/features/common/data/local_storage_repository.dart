abstract class LocalStorageRepository {
  List<String> loadCollapsedFixedExpenses();
  Future<void> updateCollapsedFixedExpenses(List<String> expenseIds);
}