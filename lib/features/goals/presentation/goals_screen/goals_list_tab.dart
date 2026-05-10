import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/components/delete_goal_dialog.dart';
import 'package:expense_tracker/features/goals/components/goal_list_item.dart';
import 'package:expense_tracker/features/goals/presentation/goals_screen/goals_screen_controller.dart';
import 'package:expense_tracker/features/goals/providers/goal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsListTab extends ConsumerStatefulWidget {

  const GoalsListTab({super.key});

  @override
  ConsumerState<GoalsListTab> createState() => _GoalsListTabState();
}

class _GoalsListTabState extends ConsumerState<GoalsListTab> {

  @override
  Widget build(BuildContext context) {
    final goalList = ref.watch(goalListProvider);
    final list = [...goalList, ...goalList, ...goalList];


    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        separatorBuilder: (_,_) => SizedBox(height: 6),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final goal = list[index];

          return GoalListItem(
              goal: goal,
              onDelete: _showDeleteGoalPopup
          );
        },
    );
  }

  Future<void> _showDeleteGoalPopup(Goal goal) async {
    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return DeleteGoalDialog(
    //       goal: goal,
    //       onConfirm: () => _handleOnDelete(goal.id!),
    //     );
    //   },
    // );
  }

  Future<void> _handleOnDelete(String goalId) async {
    final success = await ref
        .read(goalsScreenControllerProvider.notifier)
        .deleteGoal(goalId);

    if (success) {
      ToastService.showSuccessToast("Opsarings mål blev slettet!");
    } else {
      ToastService.showErrorToast("Kunne ikke slette opsparingsmål");
    }
  }
}
