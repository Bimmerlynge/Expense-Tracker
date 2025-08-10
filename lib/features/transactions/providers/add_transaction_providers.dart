
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedAmountProvider= StateProvider<double>((ref) => 0.0);
final selectedTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.expense);
final selectedPersonProvider = StateProvider<Person>((ref) {
  return ref.read(currentUserProvider);
});
final selectedCategory = StateProvider<Category?>((ref) => null);
final selectedDescriptionProvider = StateProvider<String>((ref) => '');

