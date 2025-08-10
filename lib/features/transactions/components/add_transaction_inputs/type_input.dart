import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/app/shared/components/radio_button.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeInput extends ConsumerWidget {
  const TypeInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedTypeProvider);
    final selectedNotifier = ref.read(selectedTypeProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RadioButton<TransactionType>(
            value: TransactionType.expense,
            selectedValue: selected,
            child: Text('Forbrug'),
            onSelected: (value) => selectedNotifier.state = value,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: RadioButton<TransactionType>(
            value: TransactionType.income,
            selectedValue: selected,
            child: Text('Indkomst'),
            onSelected: (value) => selectedNotifier.state = value,
          ),
        ),
      ],
    );
  }

  void onSelected() {}
}
