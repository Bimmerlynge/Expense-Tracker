import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DescriptionInput extends ConsumerWidget {
  final FocusNode focusNode;

  const DescriptionInput({super.key, required this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = ref.watch(selectedDescriptionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Description',
            style: TextStyle(color: AppColors.primaryText),
          ),
        ),
        inputContainer(
          TextFormField(
            focusNode: focusNode,
            initialValue: description,
            onChanged: (value) =>
                ref.read(selectedDescriptionProvider.notifier).state = value,
            style: TextStyle(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
