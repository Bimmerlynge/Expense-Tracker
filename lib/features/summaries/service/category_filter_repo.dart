import 'package:expense_tracker/app/repository/category_filter_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryFilterRepo implements CategoryFilterApi {
  final SharedPreferences prefs;
  static const _excludedKey = "excluded_categories";

  CategoryFilterRepo({required this.prefs});

  @override
  Future<List<String>> loadExcluded() async {
    return prefs.getStringList(_excludedKey) ?? [];
  }

  @override
  Future<void> updateExcluded(List<String> categories) async {
    await prefs.setStringList(_excludedKey, categories);
  }
}