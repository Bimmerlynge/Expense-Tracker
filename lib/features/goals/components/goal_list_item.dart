import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:flutter/material.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;

  const GoalListItem({
    super.key,
    required this.goal
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: AppColors.secondary,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            _buildImage(),
            const SizedBox(width: 12),
            _buildInfo()
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 90,
        height: 90,
        child: goal.uri != null
          ? Image.network(
              goal.uri!,
              fit: BoxFit.cover,
            )
          : Image.asset('lib/app/assets/images/istockphoto.jpg', fit: BoxFit.cover)
      ),
    );
  }

  Widget _buildInfo() {
    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            const SizedBox(height: 6),
            _progressBar(),
            const SizedBox(height: 6),
            _amountsRow()
          ],
        )
    );
  }

  Text _title() {
    return Text(
        goal.title,
        style: TTextTheme.mainTheme.labelMedium?.copyWith(
          fontSize: 18, fontWeight: FontWeight.bold,
          color: Colors.white70
        ),
    );
  }

  Widget _progressBar() {
    final progress = (goal.currentAmount / goal.goalAmount).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.grey.shade300,
        color: Colors.green.shade400,
      ),
    );
  }

  Widget _amountsRow() {
    final remaining = goal.goalAmount - goal.currentAmount;
    final percentSaved = ((goal.currentAmount / goal.goalAmount)
        .clamp(0.0, 1.0) * 100).toStringAsFixed(0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${goal.currentAmount.toStringAsFixed(0)} opsparet',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(letterSpacing: 2, color: Colors.white60),
            ),
            Text(
             '${remaining.toStringAsFixed(0)} tilbage',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(letterSpacing: 2, color: Colors.white60),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$percentSaved% opsparet',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(color: Colors.green, letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            Text(
              '${goal.goalAmount.toStringAsFixed(0)} i alt',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(letterSpacing: 2, color: Colors.white60),
            )
          ],
        )
      ],
    );
  }
}
