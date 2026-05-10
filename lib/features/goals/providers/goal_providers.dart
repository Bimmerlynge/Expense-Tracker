import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/application/goal_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showOnlyMyGoalsProvider = StateProvider<bool>((ref) => false);

final goalListStreamProvider = StreamProvider<List<Goal>>((ref) {
  final service = ref.watch(goalServiceProvider);
  final currentUserId = ref.read(currentUserProvider).id;
  final showOnlyMine = ref.watch(showOnlyMyGoalsProvider);

  return service.getGoalsStream().map(
        (goals) => goals
        .where((goal) => _isVisibleGoal(goal, currentUserId, showOnlyMine))
        .toList(),
  );
});

bool _isVisibleGoal(Goal goal, String currentUserId, bool showOnlyMine) {
  if (!_isAllowedGoal(goal, currentUserId)) return false;

  if (showOnlyMine) {
    return goal.creator.id == currentUserId;
  }

  return true;
}

bool _isAllowedGoal(Goal goal, String currentUserId) {
  return goal.creator.id == currentUserId || goal.isShared;
}

final goalListProvider = Provider<List<Goal>>((ref) {
  final goalsAsync = ref.watch(goalListStreamProvider);

  return goalsAsync.maybeWhen(
      data: (list) => list,
      orElse: () => []);
});
