import 'dart:async';

import 'package:expense_tracker/core/bootstrap/version_resolver.dart';
import 'package:expense_tracker/features/fixed_expenses/application/fixed_expenses_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  return AppLifecycleService(ref.read(versionResolverProvider), ref);
});

class AppLifecycleService with WidgetsBindingObserver {
  BuildContext? _buildContext;
  StreamSubscription? _subscription;

  final VersionResolver _versionResolver;
  final Ref _ref;

  AppLifecycleService(this._versionResolver, this._ref);

  void init(BuildContext context) {
    _buildContext = context;

    WidgetsBinding.instance.addObserver(this);

    final service = _ref.read(fixedExpenseServiceProvider);

    _subscription = service.getAllFixedExpensesStream().listen((expenses) {
      if (expenses.isNotEmpty) {
        service.registerAutoPayFixedExpenses(expenses);
        _subscription?.cancel();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runChecks();
    });
  }

  Future<void> _runChecks() async {
    final ctx = _buildContext;
    if (ctx == null) return;

    await _versionResolver.checkForUpdate(ctx);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runChecks();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _subscription?.cancel();
    _buildContext = null;
  }
}
