import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/goals/presentation/goals_screen/goals_list_tab.dart';
import 'package:expense_tracker/features/goals/presentation/goals_screen/goals_screen_header.dart';

class SavingGoalsSection extends TabPageSection {
  SavingGoalsSection():
      super(
        body: GoalsListTab(),
        header: GoalsScreenHeader(),
        headerHeightExtension: 55,
        transparentBody: true
      );
}