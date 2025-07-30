import 'package:expense_tracker/domain/person.dart';

abstract class UserApi {
  Future<Person> getCurrentUser(String uid);
}