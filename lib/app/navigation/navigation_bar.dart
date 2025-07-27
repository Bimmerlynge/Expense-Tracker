import 'package:flutter/material.dart';

class PageNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const PageNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onSelect,
      items: [
        _item(Icons.home, 'Home'),
        _item(Icons.compare_arrows, 'Transactions'),
        _item(Icons.settings, 'Setting')
      ]);
  }

  BottomNavigationBarItem _item(IconData icon, String label) {
    return BottomNavigationBarItem(
        icon: Icon(icon),
        label: label
    );
  }
}
