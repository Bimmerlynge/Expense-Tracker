import 'dart:async';

import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/application/goal_service.dart';
import 'package:expense_tracker/features/goals/providers/goal_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goals_screen_controller.g.dart';

@riverpod
class GoalsScreenController extends _$GoalsScreenController {
  late final StreamSubscription<List<Goal>> _subscription;

  @override
  FutureOr<List<Goal>> build() {
    state = AsyncLoading();

    final stream = _filteredGoalsStream();

    _subscription = stream.listen(
      (goals) => state = AsyncData(goals),
      onError: (error, stack) => state = AsyncError(error, stack),
    );

    ref.onDispose(() => _subscription.cancel());

    return stream.first;
  }

  Stream<List<Goal>> _filteredGoalsStream() {
    final service = ref.watch(goalServiceProvider);
    final currentUserId = ref.read(currentUserProvider).id;
    final showOnlyMine = ref.watch(showOnlyMyGoalsProvider);

    return service.getGoalsStream().map(
      (goals) => goals
          .where((goal) => _isVisibleGoal(goal, currentUserId, showOnlyMine))
          .toList(),
    );
  }

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

  Future<bool> deleteGoal(String goalId) async {
    return await ref.read(goalServiceProvider).deleteGoal(goalId);
  }
}
