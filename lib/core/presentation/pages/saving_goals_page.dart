import 'package:expense_tracker/design_system/pages/tab_page.dart';
import 'package:expense_tracker/features/goals/presentation/goals_screen/goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavingGoalsPage extends ConsumerStatefulWidget {
  const SavingGoalsPage({super.key});

  @override
  ConsumerState<SavingGoalsPage> createState() => _SavingGoalsPageState();
}

class _SavingGoalsPageState extends ConsumerState<SavingGoalsPage> {

  @override
  Widget build(BuildContext context) {
    return TabPage(
        title: "Opsparingsmål",
        body: GoalsScreen(),
        tabs: [],
        onTabSelected: (_) {}
    );
  }
}
