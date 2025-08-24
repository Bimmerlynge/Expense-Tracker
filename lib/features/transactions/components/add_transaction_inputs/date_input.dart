import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateInput extends ConsumerStatefulWidget {
  const DateInput({super.key});

  @override
  ConsumerState<DateInput> createState() => _DateInputState();
}

class _DateInputState extends ConsumerState<DateInput> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateNotifier = ref.read(selectedDateProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: inputContainer(
            TextFormField(
              controller: TextEditingController(
                text: DateFormat("dd-MM-yyyy").format(selectedDate),
              ),
              style: TextStyle(color: AppColors.onPrimary),
              textAlign: TextAlign.center,
              readOnly: true,
            )
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(16.0),
            ),
              onPressed: () async {
                final date = await showDatePickerDialog(
                  initialDate: selectedDate,
                  context: context,
                  maxDate: DateTime(2026),
                  minDate: DateTime(2025)
                );

                if (date != null) {
                   selectedDateNotifier.state = date;
                }
              },
              child: Text('Ændre dato')
          ),
        )
      ],
    );
  }
}
