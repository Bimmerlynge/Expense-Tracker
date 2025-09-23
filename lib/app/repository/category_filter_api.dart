abstract class CategoryFilterApi {
  Future<List<String>> loadExcluded();
  Future<void> updateExcluded(List<String> categories);
}