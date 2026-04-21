import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/users/application/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'household_users_stream_provider.g.dart';

@riverpod
Stream<List<Person>> householdUsersStream(Ref ref) {
  return ref.watch(userServicerProvider).getHouseholdUsersStream();
}