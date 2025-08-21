import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/core/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categoryStreamProvider);
    ref.watch(personStreamProvider);

    return MainScreen();
  }
}
