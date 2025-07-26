import 'package:expense_tracker/app/network/dio_api_client.dart';
import 'package:expense_tracker/features/transactions/service/transaction_service.dart';
import 'package:expense_tracker/features/transactions/view_model/transaction_view_model.dart';
import 'package:flutter/material.dart';

import '../../../app/network/mock/mock_dio_setup.dart';
import '../../../domain/transaction.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView({super.key});

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  late final TransactionViewModel viewModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    viewModel = TransactionViewModel(TransactionService(DioApiClient(dio)));
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    print("loading data");
    await viewModel.loadTransactions();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: viewModel.transactions.length,
      itemBuilder: (context, index) {
        final tx = viewModel.transactions[index];
        return ListTile(
          leading: Icon(
            tx.type == TransactionType.expense
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: tx.type == TransactionType.expense ? Colors.red : Colors.green,
          ),
          title: Text(tx.category.name),
          subtitle: Text(tx.createdTime?.toIso8601String() ?? ''),
          trailing: Text('${tx.amount} DKK'),
        );
      },
    );
  }
}
