import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/balance_chart/balance_chart_tab.dart';
import 'package:flutter/cupertino.dart';

class BalanceChartSection extends TabPageSection {
  BalanceChartSection():
      super(
        body: BalanceChartTab(),
        header: Align(
            alignment: Alignment.centerLeft,
            child: HeaderTitle(
                title: 'Samlet balance overblik')
        )
      );
}