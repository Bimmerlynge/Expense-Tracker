import 'package:expense_tracker/domain/goal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  throw UnimplementedError("GoalRepository must be overridden");
});

abstract class GoalRepository {
  Stream<List<Goal>> getGoalsStream();
  Future<bool> createGoal(Goal goal);
  Future<bool> updateGoal(Goal goal);
  Future<bool> removeGoal(String goalId);
}