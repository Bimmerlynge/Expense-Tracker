import 'package:expense_tracker/version_resolver.dart';
import 'package:flutter/material.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {


  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    final resolver = VersionResolver();
    await resolver.checkForUpdate(context);
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      body: Center(
        child: Text('Checking for update'),
      ),
    );
  }
}