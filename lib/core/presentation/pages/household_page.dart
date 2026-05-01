import 'package:expense_tracker/design_system/pages/tab_page.dart';
import 'package:expense_tracker/features/categories/presentation/category_list/category_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HouseholdPage extends ConsumerStatefulWidget {
  const HouseholdPage({super.key});

  @override
  ConsumerState<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends ConsumerState<HouseholdPage> {
  @override
  Widget build(BuildContext context) {
    return TabPage(
        section: CategoryListSection(),
        tabs: [],
        onTabSelected: (_) {}
    );
  }
}
