import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/features/transactions/view/add_transaction_screen.dart';
import 'package:flutter/material.dart';

class PageNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const PageNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.onPrimary.withAlpha(100), width: 1), // 👈 top border
        )
      ),
      child: BottomAppBar(
        notchMargin: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navItem(icon: Icons.bar_chart, label: 'Home', index: 0),
              _navItem(
                icon: Icons.compare_arrows,
                label: 'Transactions',
                index: 1,
              ),
              _addTransaction(context),
              _navItem(icon: Icons.house, label: 'Household', index: 2),
              _navItem(icon: Icons.settings, label: 'Settings', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addTransaction(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(14)
      ),
        onPressed: () => onAddTransaction(context),
        child: Icon(Icons.add)
    );
  }

  void onAddTransaction(BuildContext context) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => AddTransactionScreen(),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? AppColors.onPrimary
                : AppColors.onPrimary.withAlpha(100),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.onPrimary
                  : AppColors.onPrimary.withAlpha(100),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
