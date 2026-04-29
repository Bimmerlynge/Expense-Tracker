import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/features/summaries/components/category_list_item.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending.dart';
import 'package:flutter/material.dart';

class CategoryBarChartNew extends StatelessWidget {
  final List<CategorySpending> items;

  const CategoryBarChartNew({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: items.length,
      separatorBuilder: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(
          color: AppColors.primaryText.withAlpha(80),
        ),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CategoryItem(item: item, nameWidth: _getMaxTextWidth(), maxValue: _getMaxAmount());
      },
    );
  }

  double _getMaxAmount() {
    if (items.isEmpty) return 0;

    return items
        .map((e) => e.total)
        .reduce((a, b) => a > b ? a : b);
  }

  double _getMaxTextWidth() {
    final textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    double maxWidth = 0;

    for (final item in items) {
      final painter = TextPainter(
        text: TextSpan(text: item.name, style: textStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      if (painter.width > maxWidth) {
        maxWidth = painter.width;
      }
    }

    return maxWidth;
  }
}
