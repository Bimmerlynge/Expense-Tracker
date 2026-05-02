import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/add_fixed_expense/create_fixed_expense_modal.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/add_fixed_expense/add_fixed_expense_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseListHeader extends ConsumerWidget {
  const FixedExpenseListHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: HeaderTitle(
                title: 'Mine faste udgifter')
        ),
        SizedBox(height: 16,),
        _addFixedExpense(context),
      ],
    );
  }

  Widget _addFixedExpense(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showAddFixedExpensePopup(context),
      icon: const Icon(Icons.add),
      label: const Text('Opret fast udgift'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.whiter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
          side: BorderSide(
            color: AppColors.secondary,
            width: 1,
          ),
        ),
      ),
    );
  }

  void _showAddFixedExpensePopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CreateFixedExpenseModal();
      },
    );
  }
}
