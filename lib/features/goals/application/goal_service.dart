import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/data/goal_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalServiceProvider = Provider<GoalService>((ref) {
  return GoalService(
      goalRepository: ref.read(goalRepositoryProvider)
  );
});

class GoalService {
  final GoalRepository goalRepository;

  GoalService({required this.goalRepository});

  Future<bool> createGoal(Goal goal) async {
    return await goalRepository.createGoal(goal);
  }

  Stream<List<Goal>> getGoalsStream() {
    return goalRepository.getGoalsStream();
  }
}