import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/users/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseUserRepository implements UserRepository {
  final Ref ref;

  FirebaseUserRepository({required this.ref});

  @override
  Stream<List<Person>> getHouseholdUsersStream() {
    final householdId = ref.watch(currentUserProvider).householdId;

    var response = ref.read(firestoreProvider)
        .collection('households')
        .doc(householdId)
        .collection('users')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => Person.fromFirestore(doc)).toList(),
    );

    return response;
  }
}