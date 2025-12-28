import 'package:expense_tracker/features/fixed_expenses/presentation/fixed_expense_list/fixed_expense_list_screen.dart';
import 'package:expense_tracker/features/transactions/presentation/transaction_list/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancePage extends ConsumerStatefulWidget {
  const FinancePage({super.key});

  @override
  ConsumerState<FinancePage> createState() => _TransactionPageState();
}

class _TransactionPageState extends ConsumerState<FinancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _tabs = [
    TransactionListScreen(),
    FixedExpenseListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _setupTabController();
  }

  void _setupTabController() {
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, boxIsScrolled) =>
            _headerSliverBuilder(context, boxIsScrolled),
        body: _buildTabBarView(),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context, bool boxIsScrolled) {
    return <Widget>[
      SliverAppBar(pinned: true, toolbarHeight: 16, bottom: _buildTabBar()),
    ];
  }

  TabBar _buildTabBar() {
    return TabBar(
      tabs: [
        Tab(child: Icon(Icons.swap_horiz_outlined)),
        Tab(child: Icon(Icons.event_note_outlined)),
      ],
      controller: _tabController,
    );
  }

  TabBarView _buildTabBarView() {
    return TabBarView(controller: _tabController, children: _tabs);
  }
}
