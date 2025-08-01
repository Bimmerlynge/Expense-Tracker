import 'package:expense_tracker/app/shared/components/add_entry_form.dart';
import 'package:expense_tracker/features/transactions/view/transaction_list_view.dart';
import 'package:expense_tracker/views/home_page.dart';
import 'package:expense_tracker/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/config/environment/environment.dart';
import '../app/navigation/navigation_bar.dart';
import '../app/providers/app_providers.dart';

class MainScreen extends ConsumerStatefulWidget {

  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const TransactionListView(),
    const Scaffold(),
    const SettingsPage()
  ];

  void onPageSelect(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(transactionViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(Environment.apiUrl),
        centerTitle: true,
      ),
      bottomNavigationBar: PageNavigationBar(
        currentIndex: _currentPageIndex,
        onSelect: onPageSelect,
      ),
      body: _pages[_currentPageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddEntryForm(
            onSubmit: (transaction) {
              viewModel.addTransaction(transaction);
              // Navigator.of(context).pop();
            },
          ),
        ),
          child: const Icon(Icons.add),
        ),
      );

  }
}
