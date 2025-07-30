import 'package:expense_tracker/app/network/user_api.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService implements UserApi {
  final String collection = 'users';
  final FirebaseFirestore firestore;

  UserFirestoreService(this.firestore);

  @override
  Future<Person> getCurrentUser(String uid) async {
    var response = await firestore.collection(collection).doc(uid).get();

    return Person.fromJson(response.data()!);
  }


}