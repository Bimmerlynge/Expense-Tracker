import 'package:expense_tracker/features/categories/presentation/category_list/category_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HouseholdPage extends ConsumerStatefulWidget {
  const HouseholdPage({super.key});

  @override
  ConsumerState<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends ConsumerState<HouseholdPage>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, boxIsScrolled) =>
                _headerSliverBuilder(context, boxIsScrolled),
            body: _buildBody()
        )
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context,
      bool boxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        toolbarHeight: 16,
      )
    ];
  }

  Widget _buildBody() {
    return CategoryListScreen();
  }
}