import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/fixed_expense_list_screen_new.dart';

class FixedExpenseListSection extends TabPageSection {
  FixedExpenseListSection():
      super(
        body: FixedExpenseListScreenNew(),
        header: HeaderTitle(title: 'Mine faste udgifter')
      );
}