import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/non_scrollable_tab.dart';
import 'package:expense_tracker/design_system/pages/tab_page.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/balance_chart/balance_chart_screen.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/category_chart_screen.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryPageNew extends ConsumerStatefulWidget {
  const SummaryPageNew({super.key});

  @override
  ConsumerState<SummaryPageNew> createState() => _SummaryPageNewState();
}

class _SummaryPageNewState extends ConsumerState<SummaryPageNew>
    with SingleTickerProviderStateMixin {
  var _screenIndex = 0;

  final List<Widget> _screens = [
    CategoryChartScreen(),
    NonScrollableTab(child: BalanceChartScreen()),
    NonScrollableTab(child: HistoricChartScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return TabPage(
      title: "Denne måneds forbrug",
      body: _screens[_screenIndex],
      tabs: [
        Tab(icon: Icon(Icons.bar_chart, color: AppColors.white)),
        Tab(icon: Icon(Icons.person, color: AppColors.white)),
        Tab(icon: Icon(Icons.show_chart, color: AppColors.white)),
      ],
      onTabSelected: (index) {
        setState(() {
          _screenIndex = index;
        });
      },
    );
  }
}
