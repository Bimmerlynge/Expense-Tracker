import 'package:expense_tracker/features/transactions/view/transaction_list_view.dart';
import 'package:expense_tracker/views/home_page.dart';
import 'package:expense_tracker/views/settings_page.dart';
import 'package:flutter/material.dart';

import '../app/config/environment/environment.dart';
import '../app/navigation/navigation_bar.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const TransactionListView(),
    const SettingsPage()
  ];


  onAddEntry() {
    print("Add Entry");
  }

  void onPageSelect(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(Environment.apiUrl),
        centerTitle: true
      ),
      bottomNavigationBar: PageNavigationBar(
        currentIndex: _currentPageIndex,
        onSelect: onPageSelect,
      ),
      body: _pages[_currentPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: onAddEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}
