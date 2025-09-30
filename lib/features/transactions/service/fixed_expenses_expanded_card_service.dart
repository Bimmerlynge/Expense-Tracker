import 'package:expense_tracker/core/bootstrap/prefences/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fixedExpenseCollapsedCardProvider = Provider<FixedExpenseCollapsedCardService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FixedExpenseCollapsedCardService(prefs: prefs);
});

class FixedExpenseCollapsedCardService {
  final SharedPreferences prefs;
  static const _collapsedKey = 'collapsed_fixed_expenses';

  FixedExpenseCollapsedCardService({required this.prefs});

  List<String> loadExpanded() {
    return prefs.getStringList(_collapsedKey) ?? [];
  }

  Future<void> toggleCollapse(String expenseId) async {
    final collapsed = prefs.getStringList(_collapsedKey) ?? [];
    if (collapsed.contains(expenseId)) {
      collapsed.remove(expenseId);
    } else {
      collapsed.add(expenseId);
    }
    await prefs.setStringList(_collapsedKey, collapsed);
  }
}