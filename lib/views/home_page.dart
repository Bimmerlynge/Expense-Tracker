import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/features/transactions/view/total_expense_chart.dart';
import 'package:expense_tracker/features/transactions/view/transaction_list_view.dart';
import 'package:expense_tracker/features/users/service/user_firestore_service.dart';
import 'package:expense_tracker/features/users/view_model/user_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/shared/components/add_entry_form.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (Person person) {
        return Scaffold(
          body: Column(
            children: [
              Text(
                'Hello, ${person.name}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Expanded(
                child: Text('yo'), // Or TransactionListView(), etc.
              ),
            ],
          ),
        );
      },
    );
  }
}
