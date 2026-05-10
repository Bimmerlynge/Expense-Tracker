import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:flutter/material.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;
  final Future<void> Function(Goal) onDelete;

  const GoalListItem({super.key, required this.goal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: [
        Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: AppColors.whiter,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Row(
              children: [
                _buildImage(),
                const SizedBox(width: 12),
                _buildInfo(),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 15,
          child: InkWell(
            onTap: () async {
              await onDelete(goal);
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.whiter,
                borderRadius: BorderRadius.circular(45),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ]
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
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
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'lib/app/assets/images/istockphoto.jpg',
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                'lib/app/assets/images/istockphoto.jpg',
                fit: BoxFit.cover,
              ),
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
          _amountsRow(),
        ],
      ),
    );
  }

  Text _title() {
    return Text(
      goal.title,
      style: TTextTheme.mainTheme.labelMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
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
    final percentSaved =
        ((goal.currentAmount / goal.goalAmount).clamp(0.0, 1.0) * 100)
            .toStringAsFixed(0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${goal.currentAmount.toStringAsFixed(0)} opsparet',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(
                color: Colors.black87,
              ),
            ),
            Text(
              '${remaining.toStringAsFixed(0)} tilbage',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$percentSaved% opsparet',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${goal.goalAmount.toStringAsFixed(0)} i alt',
              style: TTextTheme.mainTheme.bodySmall?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
