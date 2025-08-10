import 'package:expense_tracker/app/network/user_api.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserFirestoreService implements UserApi {
  final String collection = 'users';
  final FirebaseFirestore firestore;
  final Ref _ref;

  UserFirestoreService(this.firestore, this._ref);

  @override
  Future<Person?> getCurrentUser() async {
    try {
      var authedUser = FirebaseAuth.instance.currentUser;
      var response = await firestore
          .collection(collection)
          .doc(authedUser!.uid)
          .get();

      return Person.fromJson(response.data()!);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<Person>> getHouseholdUsers() {
    final householdId = _ref.watch(currentUserProvider).householdId;

    var response = firestore
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
