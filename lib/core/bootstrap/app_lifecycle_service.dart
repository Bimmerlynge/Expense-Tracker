import 'dart:async';

import 'package:expense_tracker/core/bootstrap/version_resolver.dart';
import 'package:expense_tracker/features/transactions/providers/fixed_expense_view_model_provider.dart';
import 'package:expense_tracker/features/transactions/view_model/fixed_expense_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  return AppLifecycleService(
    ref.read(versionResolverProvider),
    ref
  );
});

class AppLifecycleService with WidgetsBindingObserver {
  BuildContext? _buildContext;
  StreamSubscription? _subscription;

  final VersionResolver _versionResolver;
  final Ref _ref;
  late FixedExpenseViewModel _fixedExpenseViewModel;

  AppLifecycleService(this._versionResolver, this._ref);

  void init(BuildContext context) {
    _fixedExpenseViewModel = _ref.read(fixedExpenseViewModelProvider.notifier);
    _buildContext = context;

    WidgetsBinding.instance.addObserver(this);

    _subscription = _fixedExpenseViewModel.onDataLoaded.listen((_) {
      _fixedExpenseViewModel.registerAutoPayExpenses();
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
    _subscription?.cancel();
    _buildContext = null;
  }
}