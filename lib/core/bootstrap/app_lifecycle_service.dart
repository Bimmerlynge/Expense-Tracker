import 'dart:async';

import 'package:expense_tracker/core/bootstrap/version_resolver.dart';
import 'package:expense_tracker/design_system/modals/new_update_modal.dart';
import 'package:expense_tracker/features/fixed_expenses/application/fixed_expenses_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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

    final update = await _versionResolver.checkForUpdate(ctx);
    if (!update.hasUpdate) return;

    showDialog(
        context: ctx,
        builder: (_) => NewUpdateModal(onDownload: () {
          Navigator.pop(ctx);
          _performUpdate(ctx, update.downloadUrl);
        })
    );
  }

  Future<void> _performUpdate(BuildContext context, String url) async {
    try {
      await _showProgressDialog(context, 'Downloader opdatering...');

      await _downloadApk(url);

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kunne ikke opdatere appen.')),
        );
      }
    }
  }

  Future<void> _downloadApk(String apkUrl) async {
    final uri = Uri.parse(apkUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _showProgressDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(message),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Vent venligst...'),
          ],
        ),
      ),
    );
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
