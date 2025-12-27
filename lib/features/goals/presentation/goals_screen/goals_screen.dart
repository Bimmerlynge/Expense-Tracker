import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/common/widget/async_value_widget.dart';
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
              data: (goals) => _buildList(goals)
            )
        )
      ]
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.primarySecondText.withAlpha(100), width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Switch(
                  value: ref.watch(showOnlyMyGoalsProvider),
                  onChanged: (val) {
                    ref.read(showOnlyMyGoalsProvider.notifier).state = val;
                  },
                  inactiveThumbColor: AppColors.onPrimary.withAlpha(150),
                  inactiveTrackColor: AppColors.secondary.withAlpha(150),
                  trackOutlineColor: WidgetStateProperty.all(
                      AppColors.onPrimary.withAlpha(150)),
                  activeTrackColor: AppColors.onPrimary.withAlpha(220),
                  thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white70;
                    }
                    return AppColors.onPrimary;
                  })
                ),
                Text('Vis kun mine mål', style: Theme.of(context).primaryTextTheme.labelSmall),
              ],
            ),
            TextButton.icon(
              onPressed: _showCreateSavingGoal,
              icon: Icon(Icons.add, color: AppColors.onPrimary),
              label: Text(
                'Opret mål',
                style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSavingGoal() async {
    await showDialog(
        context: context,
        builder: (context) {
          return CreateSavingGoalPopup();
        }
    );
  }

  Widget _buildList(List<Goal> goals) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];

          return GestureDetector(
              onTap: () => _showGoalPopup(goal) ,
              child: GoalListItem(goal: goal)
          );
        }
    );
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
