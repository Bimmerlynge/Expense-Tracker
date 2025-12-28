import 'package:expense_tracker/app/shared/components/actions_row.dart';
import 'package:expense_tracker/app/shared/components/simple_text_button.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
import 'package:expense_tracker/features/goals/components/delete_goal_dialog.dart';
import 'package:expense_tracker/features/goals/components/goal_list_item.dart';
import 'package:expense_tracker/features/goals/presentation/goal_detail_popup/goal_detail_popup.dart';
import 'package:expense_tracker/features/goals/presentation/goals_screen/goals_screen_controller.dart';
import 'package:expense_tracker/features/goals/providers/goal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../create_saving_goal/create_saving_goal_popup.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsScreenControllerProvider);

    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Opsparingsmål',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        SizedBox(height: 8),
        _actions(),
        Expanded(
          child: AsyncValueWidget(
            value: goalsAsync,
            data: (goals) => _buildList(goals),
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    return ActionsRow(
      alignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            Toggle(
              value: ref.watch(showOnlyMyGoalsProvider),
              onToggled: (val) {
                ref.read(showOnlyMyGoalsProvider.notifier).state = val;
              },
            ),
            Text(
              'Vis kun mine mål',
              style: Theme.of(context).primaryTextTheme.labelSmall,
            ),
          ],
        ),
        SimpleTextButton(
          iconData: Icons.add,
          onPress: _showCreateSavingGoal,
          labelText: 'Opret mål',
        ),
      ],
    );
  }

  void _showCreateSavingGoal() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CreateSavingGoalPopup();
      },
    );
  }

  Widget _buildList(List<Goal> goals) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];

        return GestureDetector(
          onTap: () => _showGoalPopup(goal),
          child: GoalListItem(goal: goal, onDelete: _showDeleteGoalPopup),
        );
      },
    );
  }

  Future<void> _showDeleteGoalPopup(Goal goal) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DeleteGoalDialog(
          goal: goal,
          onConfirm: () => _handleOnDelete(goal.id!),
        );
      },
    );
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

  void _showGoalPopup(Goal goal) async {
    await showDialog(
      context: context,
      builder: (context) {
        return GoalDetailPopup(goal: goal);
      },
    );
  }
}
