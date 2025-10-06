import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/core/bootstrap/app_lifecycle_service.dart';
import 'package:expense_tracker/core/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInitializer extends ConsumerStatefulWidget {
  const AppInitializer({super.key});

  @override
  ConsumerState<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<AppInitializer> {
  AppLifecycleService? _lifecycleService;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(personStreamProvider);

      _lifecycleService = ref.read(lifecycleServiceProvider);
      _lifecycleService?.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainScreen();
  }

  @override
  void dispose() {
    _lifecycleService?.dispose();
    super.dispose();
  }
}
