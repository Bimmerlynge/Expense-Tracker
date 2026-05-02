import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_tab.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_tab_header.dart';

class CategoryListSection extends TabPageSection {
  CategoryListSection() :
      super(
        body: CategoryListTab(),
        header: CategoryListTabHeader(),
        headerHeightExtension: 55
      );
}