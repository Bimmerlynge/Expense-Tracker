import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/fixed_expense_list_header.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/fixed_expense_list_screen.dart';

class FixedExpenseListSection extends TabPageSection {
  FixedExpenseListSection():
      super(
        body: FixedExpenseListScreen(),
        header: FixedExpenseListHeader(),
        headerHeightExtension: 55
      );
}