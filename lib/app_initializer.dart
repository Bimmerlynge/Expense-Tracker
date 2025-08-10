import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/features/transactions/view/add_transaction_screen.dart';
import 'package:expense_tracker/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncSelectedCategoryProvider);
    ref.watch(personStreamProvider);

    return MainScreen();
  }
}
