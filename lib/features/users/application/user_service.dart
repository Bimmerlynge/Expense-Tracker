import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/users/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServicerProvider = Provider((ref) {
  return UserService(
      userRepository: ref.watch(userRepositoryProvider)
  );
});

class UserService {
  final UserRepository userRepository;

  UserService({required this.userRepository});

  Stream<List<Person>> getHouseholdUsersStream() {
    return userRepository.getHouseholdUsersStream();
  }
}