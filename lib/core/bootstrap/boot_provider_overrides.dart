
import 'package:expense_tracker/core/bootstrap/prefences/shared_preferences_provider.dart';
import 'package:expense_tracker/features/categories/data/category_repository.dart';
import 'package:expense_tracker/features/categories/data/firebase_category_repository.dart';
import 'package:expense_tracker/features/fixed_expenses/data/firebase_fixed_expenses_repository.dart';
import 'package:expense_tracker/features/fixed_expenses/data/fixed_expense_repository.dart';
import 'package:expense_tracker/features/goals/data/firebase_goal_repository.dart';
import 'package:expense_tracker/features/goals/data/goal_repository.dart';
import 'package:expense_tracker/features/transactions/data/firebase_transaction_repository.dart';
import 'package:expense_tracker/features/transactions/data/transaction_repository.dart';
import 'package:expense_tracker/features/users/data/firebase_user_repository.dart';
import 'package:expense_tracker/features/users/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Override>> getOverrides() async {
  return [
    await _sharedPrefsOverride(),
    ..._repositoryOverrides()
  ];
}

List<Override> _repositoryOverrides() {
  return [
    transactionRepositoryProvider.overrideWith(
        (ref) => FirebaseTransactionRepository(ref: ref)
    ),
    fixedExpenseRepositoryProvider.overrideWith(
        (ref) => FirebaseFixedExpensesRepository(ref: ref)
    ),
    userRepositoryProvider.overrideWith(
        (ref) => FirebaseUserRepository(ref: ref)
    ),
    categoryRepositoryProvider.overrideWith(
        (ref) => FirebaseCategoryRepository(ref: ref)
    ),
    goalRepositoryProvider.overrideWith(
        (ref) => FirebaseGoalRepository(ref: ref)
    )
  ];
}

Future<Override> _sharedPrefsOverride() async {
  final prefs = await SharedPreferences.getInstance();
  return sharedPreferencesProvider.overrideWithValue(prefs);
}