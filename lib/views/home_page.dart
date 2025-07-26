import 'package:expense_tracker/features/transactions/view/transaction_list_view.dart';
import 'package:flutter/material.dart';
import '../app/shared/components/add_entry_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TransactionListView();
  }
}
