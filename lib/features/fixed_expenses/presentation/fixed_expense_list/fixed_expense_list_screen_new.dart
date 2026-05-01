import 'package:dotted_border/dotted_border.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseListScreenNew extends ConsumerStatefulWidget {
  const FixedExpenseListScreenNew({super.key});

  @override
  ConsumerState<FixedExpenseListScreenNew> createState() => _FixedExpenseListScreenNewState();
}

class _FixedExpenseListScreenNewState extends ConsumerState<FixedExpenseListScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          SizedBox(height: 12,),
          _addFixedExpense(),
          _buildList()
        ],
      ),
    );
  }

  Widget _addFixedExpense() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18)
        ),
        padding: EdgeInsets.all(24),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
              padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 50),
              radius: Radius.circular(18),
              dashPattern: [6, 10],
              strokeWidth: 3,
              color: AppColors.primaryText
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(45)
                  ),
                  child: Icon(Icons.add, color: AppColors.primary),
                ),
                SizedBox(height: 12),
                Text('Opret fast udgift', style: TextStyle(color: AppColors.secondary))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Container();
  }
}
