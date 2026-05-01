import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen/add_transaction_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(12),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: AppColors.whiter,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navItem(icon: Icons.bar_chart, label: 'Overblik', index: 0),
              _navItem(icon: Icons.swap_horiz, label: 'Økonomi', index: 1),
              _addTransaction(context),
              _navItem(icon: Icons.house, label: 'Husstand', index: 2),
              _navItem(icon: Icons.savings, label: 'Opsparing', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addTransaction(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        onPressed: () => onAddTransaction(context),
        child: Icon(
          Icons.add,
          size: 28,
          color: AppColors.whiter,
        ),
      ),
    );
  }

  void onAddTransaction(BuildContext context) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => AddTransactionScreen(),//CameraScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withAlpha(20) : AppColors.whiter,
            borderRadius: BorderRadius.circular(12)
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                height: 1
              ),
            ),
          ],
        ),
      ),
    );
  }
}
