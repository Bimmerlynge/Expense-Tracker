import 'package:expense_tracker/domain/person.dart';

abstract class UserApi {
  Future<Person?> getCurrentUser();
  Stream<List<Person>> getHouseholdUsers();
}
