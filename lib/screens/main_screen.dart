import 'package:expense_tracker/app/navigation/navigation_bar.dart';
import 'package:expense_tracker/app/shared/components/app_bar.dart';
import 'package:expense_tracker/features/transactions/view/transaction_list_view.dart';
import 'package:expense_tracker/features/transactions/view/add_transaction_screen.dart';
import 'package:expense_tracker/views/home_page.dart';
import 'package:expense_tracker/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  final List<Widget> _pages = [
    const HomePage(),
    const TransactionListView(),
    const Scaffold(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _offsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.5)).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  void onPageSelect(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: 'Overview'),
      body: _pages[_currentPageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SlideTransition(
        position: _offsetAnimation,
        child: FloatingActionButton(
          elevation: 4,
          onPressed: onAddTransaction,
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: SlideTransition(
        position: _offsetAnimation,
        child: PageNavigationBar(
          currentIndex: _currentPageIndex,
          onSelect: onPageSelect,
        ),
      ),
    );
  }

  void onAddTransaction() async {
    await _animationController.forward();

    if (!mounted) return;

    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => AddTransactionScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

    if (mounted) await _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
