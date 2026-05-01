import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/historic_chart/historic_chart_screen.dart';
import 'package:flutter/cupertino.dart';

class HistoricChartSection extends TabPageSection {
  HistoricChartSection():
      super(
        body: HistoricChartScreen(),
        header: Align(
            alignment: Alignment.centerLeft,
            child: HeaderTitle(
                title: 'Kategori historik')
        )
      );
}