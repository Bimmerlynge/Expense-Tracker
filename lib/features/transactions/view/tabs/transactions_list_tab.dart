import 'package:expense_tracker/features/transactions/components/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionsListTab extends ConsumerStatefulWidget {
  const TransactionsListTab({super.key});

  @override
  ConsumerState<TransactionsListTab> createState() => _TransactionsListTabState();
}

class _TransactionsListTabState extends ConsumerState<TransactionsListTab> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          'Alle transaktioner',
          style: Theme.of(context).primaryTextTheme.labelMedium,
        ),
        Expanded(child: TransactionList())
      ],
    );
  }
}
