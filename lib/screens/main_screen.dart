import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/shared/components/add_entry_form.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:expense_tracker/features/transactions/view/transaction_list_view.dart';
import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
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
    const SettingsPage()
  ];

  void onPageSelect(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModelAsync = ref.watch(transactionViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(Environment.apiUrl),
        centerTitle: true,
      ),
      bottomNavigationBar: PageNavigationBar(
        currentIndex: _currentPageIndex,
        onSelect: onPageSelect,
      ),
      body: _pages[_currentPageIndex],
      floatingActionButton: viewModelAsync.when(
        loading: () => null,
        error: (error, stack) => null,
        data: (viewModel) => FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => AddEntryForm(
              onSubmit: (transaction) {
                viewModel.addTransaction(transaction);
              },
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
