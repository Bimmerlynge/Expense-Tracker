import 'package:expense_tracker/app/network/user_api.dart';
import 'package:expense_tracker/domain/person.dart';

class UserViewModel {
  final UserApi userApi;

  UserViewModel(this.userApi);

  Future<Person> getCurrentUser() async {
    var currentUser = await userApi.getCurrentUser();

    if (currentUser == null) {
      throw Exception("Current user was null");
    }

    return currentUser;
  }
}