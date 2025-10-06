import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
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

final householdCategoriesProvider = StateProvider<List<Category>>((ref) {
  return List.empty();
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
