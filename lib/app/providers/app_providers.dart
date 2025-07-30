import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/providers/current_user_notifier.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
import 'package:expense_tracker/features/users/service/user_firestore_service.dart';
import 'package:expense_tracker/features/users/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final authStateProvider = StreamProvider<User?>(
      (ref) => FirebaseAuth.instance.authStateChanges(),
);

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final currentUserProvider = AsyncNotifierProvider<CurrentUserNotifier, Person>(
  CurrentUserNotifier.new,
);

final userFirestoreServiceProvider = Provider<UserFirestoreService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserFirestoreService(firestore);
});

final userViewModelProvider = Provider<UserViewModel>((ref) {
  final userFirestoreService = ref.watch(userFirestoreServiceProvider);
  return UserViewModel(userFirestoreService);
});

final transactionFirestoreServiceProvider = FutureProvider<TransactionFirebaseService>((ref) async {
  final firestore = ref.read(firestoreProvider);
  final currentUserAsync = await ref.watch(currentUserProvider.future);

  return TransactionFirebaseService(firestore, currentUserAsync);
});

final transactionViewModelProvider = FutureProvider<TransactionViewModel>((ref) async {
  final transactionFirestoreService = await ref.watch(transactionFirestoreServiceProvider.future);
  return await TransactionViewModel.create(transactionFirestoreService);
});


