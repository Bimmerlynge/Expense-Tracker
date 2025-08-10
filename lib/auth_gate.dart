import 'package:expense_tracker/app_initializer.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/providers/app_providers.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userViewModel = ref.watch(userViewModelProvider);

    Future<void> setCurrentUser(User user) async {
      final person = await userViewModel.getCurrentUser();
      ref.read(currentUserProvider.notifier).state = person;
    }

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (user) {
        if (user != null) {
          return FutureBuilder(
            future: setCurrentUser(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else {
                return const AppInitializer();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
