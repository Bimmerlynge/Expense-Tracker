import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/application/goal_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_saving_goal_popup_controller.g.dart';

@riverpod
class CreateSavingGoalPopupController extends _$CreateSavingGoalPopupController {

  @override
  Goal build() {
    return Goal(
        title: "",
        creator: ref.read(currentUserProvider),
        isShared: false,
        goalAmount: 0.0,
        currentAmount: 0.0
    );
  }

  Future<bool> createSavingGoal() async {
    return await ref.read(goalServiceProvider).createGoal(state);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateIsShared(bool isShared) {
    state = state.copyWith(isShared: isShared);
  }

  void updateGoalAmount(double value) {
    state = state.copyWith(goalAmount: value);
  }

  void updateCurrentAmount(double value) {
    state = state.copyWith(currentAmount: value);
  }

  void updateUri(String uri) {
    state = state.copyWith(uri: uri);
  }
}