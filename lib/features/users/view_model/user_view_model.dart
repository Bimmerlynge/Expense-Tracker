import 'package:expense_tracker/app/network/user_api.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserViewModel {
  final UserApi userApi;

  UserViewModel(this.userApi);

  Future<Person> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return await userApi.getCurrentUser(user.uid);
  }
}