import 'package:flutter/material.dart';

class NonScrollableTab extends StatelessWidget {
  final Widget child;

  const NonScrollableTab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) => true,
      child: child,
    );
  }
}
