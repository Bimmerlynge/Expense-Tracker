import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TAppBar extends ConsumerStatefulWidget {
  const TAppBar({
    super.key,
    required this.innerBoxScrolled,
    this.tabs = const [],
    this.title = '',
    this.tabController,
  });

  final bool innerBoxScrolled;
  final String title;
  final List<Widget> tabs;
  final TabController? tabController;

  @override
  ConsumerState<TAppBar> createState() => _TAppBarState();
}

class _TAppBarState extends ConsumerState<TAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      forceElevated: widget.innerBoxScrolled,
      toolbarHeight: 56,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      title: Text(widget.title),
      bottom: (widget.tabs.isNotEmpty && widget.tabController != null)
          ? TabBar(controller: widget.tabController, tabs: widget.tabs)
          : null,
    );
  }
}
