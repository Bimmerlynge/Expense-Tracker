import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/goals/components/goal_list_item.dart';
import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _goals.length,
        itemBuilder: (context, index) {
          return GoalListItem(goal: _goals[index]);
        }
    );
  }
  
  final List<Goal> _goals = [
    Goal(title: "Test mål", creator: Person(id: "", name: ""), isShared: true, goalAmount: 1336.69, currentAmount: 420)
  ];
}
