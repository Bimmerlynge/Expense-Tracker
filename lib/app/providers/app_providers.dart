import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/categories/service/category_firebase_service.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
import 'package:expense_tracker/features/users/service/user_firestore_service.dart';
import 'package:expense_tracker/features/users/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// final currentUserProvider = AsyncNotifierProvider<CurrentUserNotifier, Person>(
//   CurrentUserNotifier.new,
// );

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

final transactionViewModelProvider =
    StateNotifierProvider<TransactionViewModel, AsyncValue<List<Transaction>>>(
      (ref) => TransactionViewModel(
        ref.watch(transactionFirestoreServiceProvider),
        ref,
      ),
    );

final categoryFirebaseServiceProvider = Provider<CategoryFirebaseService>((
  ref,
) {
  final firestore = FirebaseFirestore.instance;
  return CategoryFirebaseService(firestore, ref);
});

final householdCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.watch(categoryFirebaseServiceProvider);
  return await service.getHouseholdCategories();
});

final combinedHouseholdDataProvider =
    FutureProvider<(List<Category>, List<Person>)>((ref) async {
      final categoriesFuture = ref.watch(householdCategoriesProvider.future);

      final results = await Future.wait([categoriesFuture]);

      final categories = results[0];
      final persons = [
        Person(id: "7roAszxuATYOjRYYunZFB2Bi02y1", name: "Freja"),
        Person(id: "hAVigm8dcjMXPQqdJDFYYW3Zys83", name: "Mathias"),
      ];
      return (categories, persons);
    });

final transactionStreamProvider = StreamProvider<List<Transaction>>((ref) {
  final service = ref.watch(transactionFirestoreServiceProvider);
  return service.getTransactionsStream();
});

final categoryStreamProvider = StreamProvider<List<Category>>((ref) {
  final service = ref.watch(categoryFirebaseServiceProvider);
  return service.getCategoryStream();
});

final personStreamProvider = StreamProvider<List<Person>>((ref) {
  final service = ref.watch(userFirestoreServiceProvider);
  return service.getHouseholdUsers();
});
