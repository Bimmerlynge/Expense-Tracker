import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

import 'app_providers.dart';

class CurrentUserNotifier extends AsyncNotifier<Person> {
   late FirebaseFirestore firestore;

  @override
  FutureOr<Person> build() async {
    print('Current User Provider fetching logged in user');
    firestore = ref.read(firestoreProvider);
    final user = FirebaseAuth.instance.currentUser;
    final doc = await firestore.collection('users').doc(user!.uid).get();
    return Person.fromJson(doc.data()!);
  }

}