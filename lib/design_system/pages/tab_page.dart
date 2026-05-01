import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/design_system/background/blue_gradient_background.dart';
import 'package:expense_tracker/design_system/pages/tab_page_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabPage extends ConsumerStatefulWidget {
  final TabPageSection section;
  final List<Widget> tabs;
  final ValueChanged<int> onTabSelected;
  final double extendHeaderHeight;

  const TabPage({
    super.key,
    required this.section,
    required this.tabs,
    required this.onTabSelected,
    this.extendHeaderHeight = 0
  });

  @override
  ConsumerState<TabPage> createState() => _TabPageState();
}

class _TabPageState extends ConsumerState<TabPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  double headerHeightBuffer = 150;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _background(),
          _content(),
        ],
      ),
    );
  }

  Widget _background() {
    final topInset = MediaQuery.of(context).padding.top;

    return Container(
      height: topInset + headerHeightBuffer + widget.extendHeaderHeight,
      child: BlueLinearGradient(),
    );
  }

  Widget _content() {
    final inset = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: inset),
      child: Container(
        child: Column(
          children: [
            if (widget.tabs.isNotEmpty) ...[
              _buildTabBar(),
            ],
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: widget.section.header,
            ),
            // _header(),
            SizedBox(height: 16,),
            Expanded(child: _body())
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiter,
        borderRadius: BorderRadius.circular(16)
      ),
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: widget.section.body,
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            color: AppColors.opaqueBlueAccent,
            borderRadius: BorderRadius.circular(12),
        ),
        controller: _controller,
        tabs: widget.tabs,
        onTap: (index) => widget.onTabSelected.call(index),
      ),
    );
  }
}
