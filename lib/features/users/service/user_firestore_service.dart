import 'package:expense_tracker/app/network/user_api.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestoreService implements UserApi {
  final String collection = 'users';
  final FirebaseFirestore firestore;

  UserFirestoreService(this.firestore);

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
}
