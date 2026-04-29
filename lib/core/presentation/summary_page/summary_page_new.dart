import 'package:expense_tracker/app/shared/components/non_scrollable_tab.dart';
import 'package:expense_tracker/design_system/pages/tab_page.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/balance_chart/balance_chart_screen.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/category_chart_screen_new.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryPageNew extends ConsumerStatefulWidget {
  const SummaryPageNew({super.key});

  @override
  ConsumerState<SummaryPageNew> createState() => _SummaryPageNewState();
}

class _SummaryPageNewState extends ConsumerState<SummaryPageNew> {

  final List<Widget> _tabs = [
    CategoryChartScreenNew(),
    NonScrollableTab(child: BalanceChartScreen()),
    NonScrollableTab(child: HistoricChartScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return TabPage(
      title: "Denne måneds forbrug",
      body: _tabs[0],
    );
  }
}
