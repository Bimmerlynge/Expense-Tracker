import 'package:expense_tracker/domain/transaction.dart';

bool Function(Transaction) onlyUserPredicate(String userId) {
  return (Transaction t) => t.user.id == userId;
}

bool Function(Transaction) excludeCategoriesPredicate(List<String> excludedNames) {
  return (Transaction t) => !excludedNames.contains(t.category.name);
}