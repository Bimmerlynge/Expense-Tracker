import 'package:expense_tracker/core/bootstrap/auth_gate.dart';
import 'package:expense_tracker/core/bootstrap/version_resolver.dart';
import 'package:flutter/material.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  bool isOutdated = true;

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    final resolver = VersionResolver();
    final result = await resolver.checkForUpdate(context);
    setState(() {
      isOutdated = result;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (!isOutdated) {
      return AuthGate();
    }

    return Scaffold(
      body: Center(
        child: Text('Checking for update'),
      ),
    );
  }
}