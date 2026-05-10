import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/toggle.dart';
import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/features/goals/providers/goal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsScreenHeader extends ConsumerStatefulWidget {
  const GoalsScreenHeader({super.key});

  @override
  ConsumerState<GoalsScreenHeader> createState() => _GoalsScreenHeaderState();
}

class _GoalsScreenHeaderState extends ConsumerState<GoalsScreenHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _title(),
        _actions()
      ],
    );
  }

  Widget _title() {
    return Align(
        alignment: Alignment.centerLeft,
        child: HeaderTitle(
            title: 'Opsparingsmål')
    );
  }

  Widget _actions() {
    return Row(
      children: [
        _toggle(),
        SizedBox(width: 4),
        Text('Vis kun mine', style: TextStyle(color: AppColors.whiter)),
        Spacer(),
        _createButton()
      ],
    );
  }

  Widget _toggle() {
    return Toggle(
        trackOutlineColor: AppColors.opaqueBlueAccent,
        accentColor: AppColors.secondary,
        backgroundColor: AppColors.secondary,
        activeAccentColor: AppColors.secondary,
        value: ref.watch(showOnlyMyGoalsProvider),
        onToggled: (val) {
          ref.read(showOnlyMyGoalsProvider.notifier).state = val;
        }
    );
  }

  Widget _createButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: const Text('Opret mål'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.opaqueBlueAccent,
        foregroundColor: AppColors.whiter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
          side: BorderSide(
            color: AppColors.opaqueBlueAccent,
            width: 1,
          ),
        ),
      ),
    );
  }
}
