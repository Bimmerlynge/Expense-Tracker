import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/transactions/providers/fixed_expense_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/config/theme/app_colors.dart';

class AddFixedExpensePopup extends ConsumerStatefulWidget {
  const AddFixedExpensePopup({super.key});

  @override
  ConsumerState<AddFixedExpensePopup> createState() => _AddFixedExpensePopupState();
}

class _AddFixedExpensePopupState extends ConsumerState<AddFixedExpensePopup> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  PaymentType selectedType = PaymentType.monthly;
  DateTime selectedDueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.new_releases_outlined),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ny fast udgift'),
          const SizedBox(height: 8),
          Divider(thickness: 1, color: AppColors.onPrimary),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _titleRow(),
                  SizedBox(height: 16),
                  _amountRow(),
                  SizedBox(height: 24),
                  _typeRow(),
                  SizedBox(height: 24),
                  _dateRow(setState)
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Afbryd',
                style: TextStyle(color: AppColors.onPrimary.withAlpha(200)),
              ),
            ),
            TextButton(
              onPressed: () {
                _createFixedExpense();
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Opret',
                style: TextStyle(color: AppColors.primaryText),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _createFixedExpense() {
    final newFixedExpense = FixedExpense(
        id: '',
        title: titleController.text,
        amount: double.parse(amountController.text),
        paymentType: selectedType,
        hasBeenPaid: false,
        nextPaymentDate: selectedDueDate,
        lastPaymentDate: DateTime(1995),
        autoPay: false);

    ref.read(fixedExpenseViewModelProvider.notifier)
        .addFixedExpense(newFixedExpense);
  }

  Widget _titleRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Titel', style: TTextTheme.mainTheme.labelMedium),
        ),
        inputContainer(
          TextFormField(
            controller: titleController,
            style: TextStyle(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _amountRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Beløb', style: TTextTheme.mainTheme.labelMedium),
        ),
        inputContainer(
          TextFormField(
            controller: amountController,
            style: TextStyle(color: AppColors.onPrimary),
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _typeRow() {
    return inputContainer(
      DropdownButtonHideUnderline(
        child: DropdownButton<PaymentType>(
          alignment: Alignment.center,
          dropdownColor: AppColors.primary,
          style: TextStyle(color: AppColors.primaryText, fontSize: 16),
          value: selectedType,
          items: const [
            DropdownMenuItem(value: PaymentType.monthly, child: Text('Månedlig')),
            DropdownMenuItem(
              value: PaymentType.twoMonthly,
              child: Text('Hver 2. måned'),
            ),
            DropdownMenuItem(
              value: PaymentType.quarterly,
              child: Text('Kvartalsvis'),
            ),
          ],
          onChanged: (PaymentType? newValue) {
            setState(() {
              selectedType = newValue!;
            });
          },
        ),
      )
    );
  }

  Widget _dateRow(StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Betalings dato',),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePickerDialog(
              context: context,
              initialDate: selectedDueDate,
              minDate: DateTime(2000),
              maxDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                selectedDueDate = picked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryText),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('dd/MM/yyyy').format(selectedDueDate),
              style: TTextTheme.mainTheme.labelMedium,
            ),
          ),
        ),
      ],
    );
  }

  Row _createRow(String title, Widget inputWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Expanded(child: inputWidget)
      ],
    );
  }
}
