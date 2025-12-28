import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/application/goal_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goal_detail_popup_controller.g.dart';

@riverpod
class GoalDetailPopupController extends _$GoalDetailPopupController {
  @override
  void build() {}

  Future<bool> updateGoal(Goal goal) async {
    return await ref.read(goalServiceProvider).updateGoal(goal);
  }
}
