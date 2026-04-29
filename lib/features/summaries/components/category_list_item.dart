import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final CategorySpending item;
  final double nameWidth;
  final double maxValue;

  const CategoryItem({
    super.key,
    required this.item,
    required this.nameWidth,
    required this.maxValue
  });

  @override
  Widget build(BuildContext context) {
    final progress = item.total / maxValue;

    return Container(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.favorite_border, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Container(
            width: nameWidth,
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.containerOnPrimary
              ),
            ),
          ),
          SizedBox(width: 12,),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            item.total.toStringAsFixed(2),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}