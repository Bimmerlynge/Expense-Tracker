import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/design_system/pages/tab_page.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/fixed_expense_list_screen.dart';
import 'package:expense_tracker/features/transactions/presentation/transaction_list/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancePage extends ConsumerStatefulWidget {
  const FinancePage({super.key});

  @override
  ConsumerState<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<FinancePage>
    with SingleTickerProviderStateMixin {

  var _screenIndex = 0;

  final List<Widget> _tabs = [
    TransactionListScreen(),
    FixedExpenseListScreen(),
  ];

  final List<String> _titles = [
    "Transaktioner denne måned",
    "Mine faste udgifter"
  ];

  @override
  Widget build(BuildContext context) {
    return TabPage(
        title: _titles[_screenIndex],
        body: _tabs[_screenIndex],
        tabs: [
          Tab(child: Icon(Icons.swap_horiz_outlined, color: AppColors.white)),
          Tab(child: Icon(Icons.event_note_outlined, color: AppColors.white)),
        ],
        onTabSelected: (index) {
          setState(() {
            _screenIndex = index;
          });
        }
    );
  }
}
