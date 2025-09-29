import 'package:expense_tracker/app/navigation/navigation_bar.dart';
import 'package:expense_tracker/features/summaries/view/home_page.dart';
import 'package:expense_tracker/features/settings/view/settings_page.dart';
import 'package:expense_tracker/features/transactions/view/transaction_page.dart';
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
    const TransactionPage(),
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
      body: _pages[_currentPageIndex],
      bottomNavigationBar: SlideTransition(
        position: _offsetAnimation,
        child: PageNavigationBar(
          currentIndex: _currentPageIndex,
          onSelect: onPageSelect,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
