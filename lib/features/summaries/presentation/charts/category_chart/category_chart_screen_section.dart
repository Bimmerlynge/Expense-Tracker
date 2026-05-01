import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/summaries/presentation/charts/category_chart/category_chart_screen.dart';
import 'package:flutter/material.dart';

class CategoryChartSection extends TabPageSection {
  CategoryChartSection()
      : super(
          header: Align(
              alignment: Alignment.centerLeft,
              child: HeaderTitle(title: "Måneds forbrug")),
          body: CategoryChartScreen(),
  );
}