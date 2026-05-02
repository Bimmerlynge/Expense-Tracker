import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:flutter/material.dart';

class PaymentTypeDropdown extends StatefulWidget {
  final PaymentType value;
  final ValueChanged<PaymentType> onChanged;

  const PaymentTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged
  });

  @override
  State<PaymentTypeDropdown> createState() => _PaymentTypeDropdownState();
}

class _PaymentTypeDropdownState extends State<PaymentTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<PaymentType>(
        padding: EdgeInsets.all(0),
        alignment: Alignment.centerRight,
        dropdownColor: AppColors.white,
        style: TextStyle(color: Colors.black87),
        value: widget.value,
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
          widget.onChanged.call(newValue!);
        },
      ),
    );
  }
}
