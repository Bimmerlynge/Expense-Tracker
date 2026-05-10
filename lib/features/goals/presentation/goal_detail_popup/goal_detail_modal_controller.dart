import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/goals/application/goal_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goal_detail_modal_controller.g.dart';

@riverpod
class GoalDetailModalController extends _$GoalDetailModalController {
  @override
  Goal build(Goal goal) {
    return goal;
  }

  Future<bool> updateGoal() async {
    final goal = state;

    return await ref.read(goalServiceProvider).updateGoal(goal);
  }

  void updateUri(String uri) {
    state = state.copyWith(
      uri: uri
    );
  }

  void updateIsShared() {
    state = state.copyWith(
      isShared: !state.isShared
    );
  }

  void addToCurrent(double amount) {
    state = state.copyWith(
      currentAmount: state.currentAmount += amount
    );
  }
}
