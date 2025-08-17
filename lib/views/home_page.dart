import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => ToastService.showInfoToast(
              context,
              "This is a regular snackbar",
            ),
            child: Text("Update worked!"),
          ),
        ],
      ),
    );
  }
}
