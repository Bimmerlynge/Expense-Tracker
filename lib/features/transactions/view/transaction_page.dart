import 'package:expense_tracker/features/transactions/view/tabs/fixed_expenses_tab.dart';
import 'package:expense_tracker/features/transactions/view/tabs/transactions_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionPage extends ConsumerStatefulWidget {
  const TransactionPage({super.key});

  @override
  ConsumerState<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends ConsumerState<TransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _tabs = [
    TransactionsListTab(),
    FixedExpensesTab()
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
          body: _buildTabBarView()
      )
    );
  }

  List<Widget> _headerSliverBuilder(
      BuildContext context,
      bool boxIsScrolled
      ) {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        toolbarHeight: 16,
        bottom: _buildTabBar(),
      )
    ];
  }

  TabBar _buildTabBar() {
    return TabBar(
        tabs: [
          Tab(child: Icon(Icons.swap_horiz_outlined)),
          Tab(child: Icon(Icons.event_note_outlined))
        ],
      controller: _tabController,
    );
  }

  TabBarView _buildTabBarView() {
    return TabBarView(controller: _tabController, children: _tabs);
  }
}
