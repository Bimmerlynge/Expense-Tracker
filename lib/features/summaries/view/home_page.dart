import 'package:expense_tracker/app/shared/components/app_bar.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _createAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => ToastService.showInfoToast(
                context,
                "This is a regular snackbar",
              ),
              child: Text("Update worked!"),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
      toolbarHeight: 40,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
              tabs: [
                Tab(child: Icon(Icons.bar_chart)),
                Tab(child: Icon(Icons.area_chart_rounded)),
                Tab(child: Icon(Icons.person))
              ]
          ),
        ),
      ),
    );
  }
}
