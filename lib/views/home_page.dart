import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/features/transactions/view/total_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: Column(
        children: [
          // Text(
          //   'Hello, ${currentUser.name}',
          //   style: Theme.of(context).textTheme.titleLarge,
          // ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => ToastService.showInfoToast(
              context,
              "This is a regular snackbar",
            ),
            child: Text("Test Toast"),
          ),
          // Expanded(
          //   child: TotalExpenseChart(), // Or TransactionListView(), etc.
          // ),
        ],
      ),
    );

    // return currentUserAsync.when(
    //   loading: () => const Center(child: CircularProgressIndicator()),
    //   error: (err, stack) => Center(child: Text('Error: $err')),
    //   data: (Person person) {
    //     return Scaffold(
    //       body: Column(
    //         children: [
    //           Text(
    //             'Hello, ${person.name}',
    //             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //           ),
    //           const SizedBox(height: 20),
    //           const Expanded(
    //             child: Text('yo'), // Or TransactionListView(), etc.
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
