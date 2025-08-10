import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmountInput extends ConsumerWidget {
  const AmountInput({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(selectedAmountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Amount',
            style: TextStyle(color: AppColors.primaryText),
          ),
        ),
        inputContainer(
          TextFormField(
              initialValue: amount.toString(),
              onChanged: (value) =>
              ref.read(selectedAmountProvider.notifier).state = double.parse(value),
              style: TextStyle(
                color: AppColors.onPrimary,
              ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}