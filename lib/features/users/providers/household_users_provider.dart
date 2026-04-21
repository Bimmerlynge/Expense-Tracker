import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/users/providers/household_users_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'household_users_provider.g.dart';

@riverpod
List<Person> householdUsers(Ref ref) {
  final usersAsync = ref.watch(householdUsersStreamProvider);

  return usersAsync.maybeWhen(
    data: (users) => users,
    orElse: () => [],
  );
}