import 'package:expense_tracker/app/shared/components/non_scrollable_tab.dart';
import 'package:expense_tracker/features/summaries/view/tabs/balance_tab.dart';
import 'package:expense_tracker/features/summaries/view/tabs/category_tab.dart';
import 'package:expense_tracker/features/summaries/view/tabs/historic_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupTabController();
  }

  void _setupTabController() {
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<Widget> _tabs = [
    CategoryTab(),
    NonScrollableTab(child: BalanceTab()),
    HistoricTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: _isTabScrollable(),
        controller: _scrollController,
        headerSliverBuilder: (context, boxIsScrolled) =>
            _buildHeaderSliverBuilder(context, boxIsScrolled),
        body: _buildTabBarView(),
      ),
    );
  }

  List<Widget> _buildHeaderSliverBuilder(
    BuildContext context,
    bool boxIsScrolled,
  ) {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        floating: true,
        forceElevated: boxIsScrolled,
        toolbarHeight: 16,
        bottom: _buildTabBar(),
      ),
    ];
  }

  TabBar _buildTabBar() {
    return TabBar(
      tabs: [
        Tab(
          child: Transform.rotate(
            angle: math.pi / 2,
            child: Icon(Icons.bar_chart),
          ),
        ),
        Tab(child: Icon(Icons.person)),
        Tab(child: Icon(Icons.area_chart_rounded)),
      ],
      controller: _tabController,
    );
  }

  TabBarView _buildTabBarView() {
    return TabBarView(controller: _tabController, children: _tabs);
  }

  ScrollPhysics _isTabScrollable() {
    final isNonScrollableType = _tabs[_tabController.index] is NonScrollableTab;

    if (isNonScrollableType) {
      return NeverScrollableScrollPhysics();
    }

    return ClampingScrollPhysics();
  }
}
