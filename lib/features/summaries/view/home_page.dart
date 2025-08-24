import 'package:expense_tracker/features/summaries/view/category_tab.dart';
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
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                forceElevated: boxIsScrolled,
                toolbarHeight: 16,
                bottom: TabBar(
                  tabs: [
                    Tab(child: Transform.rotate(
                        angle: math.pi / 2,
                        child: Icon(Icons.bar_chart)
                    )
                    ),
                    Tab(child: Icon(Icons.area_chart_rounded)),
                    Tab(child: Icon(Icons.person))
                  ],
                  controller: _tabController,
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TabBarView(
              controller: _tabController,
              children: [
                CategoryTab(),
                Center(child: Text('Historic chart'),),
                Center(child: Text('My Summary'),)
              ],
            ),
          ),
      ),
    );
  }
}
