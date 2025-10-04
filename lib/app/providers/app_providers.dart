import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/categories/service/category_firebase_service.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:expense_tracker/features/users/service/user_firestore_service.dart';
import 'package:expense_tracker/features/users/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final currentUserProvider = StateProvider<Person>((ref) {
  return Person(id: "", name: "", householdId: "");
});

final userFirestoreServiceProvider = Provider<UserFirestoreService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserFirestoreService(firestore, ref);
});

final userViewModelProvider = Provider<UserViewModel>((ref) {
  final userFirestoreService = ref.watch(userFirestoreServiceProvider);
  return UserViewModel(userFirestoreService);
});

final transactionFirestoreServiceProvider =
    Provider<TransactionFirebaseService>((ref) {
      final firestore = ref.read(firestoreProvider);
      return TransactionFirebaseService(firestore, ref);
    });

final categoryFirebaseServiceProvider = Provider<CategoryFirebaseService>((
  ref,
) {
  final firestore = FirebaseFirestore.instance;
  return CategoryFirebaseService(firestore, ref);
});

final householdCategoriesProvider = StateProvider<List<Category>>((ref) {
  return List.empty();
});

final categoryStreamProvider = StreamProvider<List<Category>>((ref) {
  final service = ref.watch(categoryFirebaseServiceProvider);
  final selectedCategoryNotifier = ref.read(selectedCategoryProvider.notifier);
  final householdCategories = ref.read(householdCategoriesProvider.notifier);

  return service.getCategoryStream().map((categories) {
    if (selectedCategoryNotifier.state == null) {
      final defaultCategory = categories.firstWhere((c) => c.isDefault == true);
      selectedCategoryNotifier.state = defaultCategory;
    }

    householdCategories.state = categories;
    return categories;
  });
});

final personStreamProvider = StreamProvider<List<Person>>((ref) {
  final service = ref.watch(userFirestoreServiceProvider);
  return service.getHouseholdUsers();
});

final personListProvider = Provider<List<Person>>((ref) {
  final asyncPersons = ref.watch(personStreamProvider);

  return asyncPersons.maybeWhen(
    data: (persons) => persons,
    orElse: () => const [],
  );
});

final transactionRangeProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();

  return DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 1)
  );
});

final transactionStreamInRangeProvider = StreamProvider<List<Transaction>>((
  ref,
) {
  final range = ref.watch(transactionRangeProvider);
  final service = ref.read(transactionFirestoreServiceProvider);
  return service.getTransactionStreamInRange(range.start, range.end);
});
