import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/core/presentation/summary_page/summary_page_new.dart';
import 'package:expense_tracker/design_system/navigation/bottom_nav_bar.dart';
import 'package:expense_tracker/features/categories/presentation/household_page.dart';
import 'package:expense_tracker/features/finance/presentation/finance_page.dart';
import 'package:expense_tracker/features/goals/presentation/goals_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreenNew extends ConsumerStatefulWidget {
  const MainScreenNew({super.key});

  @override
  ConsumerState<MainScreenNew> createState() => _MainScreenNewState();
}

class _MainScreenNewState extends ConsumerState<MainScreenNew> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const SummaryPageNew(),
    const FinancePage(),
    const HouseholdPage(),
    const GoalsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onSelect: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
