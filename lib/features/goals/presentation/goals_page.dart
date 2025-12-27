import 'package:expense_tracker/features/goals/presentation/goals_screen/goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage>
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
    return GoalsScreen();
  }
}