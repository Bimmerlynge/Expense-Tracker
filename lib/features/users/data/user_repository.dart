import 'package:expense_tracker/domain/person.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  throw UnimplementedError('UserRepository must be overridden');
});

abstract class UserRepository {
  Stream<List<Person>> getHouseholdUsersStream();
}