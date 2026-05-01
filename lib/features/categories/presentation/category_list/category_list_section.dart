import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_screen.dart';
import 'package:flutter/cupertino.dart';

class CategoryListSection extends TabPageSection {
  CategoryListSection() :
      super(
        body: CategoryListScreen(),
        header: Align(
            alignment: Alignment.centerLeft,
            child: HeaderTitle(
                title: 'Kategorier')
        )
      );
}