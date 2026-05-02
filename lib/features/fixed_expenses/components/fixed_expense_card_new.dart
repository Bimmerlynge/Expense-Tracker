import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/design_system/primitives/number_editable_field.dart';
import 'package:expense_tracker/app/shared/widgets/gray_box.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/extensions/date_utils_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseCardNew extends ConsumerStatefulWidget {
  final FixedExpense fixedExpense;
  final bool isExpanded;
  final ValueChanged<String> onToggleCollapse;
  final ValueChanged<FixedExpense> onChanged;
  final void Function(FixedExpense expense) onManualPay;

  const FixedExpenseCardNew({
    super.key,
    required this.fixedExpense,
    this.isExpanded = true,
    required this.onToggleCollapse,
    required this.onChanged,
    required this.onManualPay
  });

  @override
  ConsumerState<FixedExpenseCardNew> createState() => _FixedExpenseCardNewState();
}

class _FixedExpenseCardNewState extends ConsumerState<FixedExpenseCardNew> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.whiter,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _header(),
            if (widget.isExpanded) ...[
              SizedBox(height: 12,),
              Divider(color: AppColors.primaryText.withAlpha(50),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _body(),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        _titleRow(),
        SizedBox(height: 8),
        _amountRow()
      ],
    );
  }

  Widget _titleRow() {
    return Row(
      children: [
        _wrappedIcon(),
        const SizedBox(width: 8),
        Text(
          widget.fixedExpense.title,
          style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500
          ),
        ),
        const Spacer(),
        Text('Automatisk', style: TextStyle(color: AppColors.secondary)),
        const SizedBox(width: 4),
        _autoPayIndicator(),
        SizedBox(width: 6),
        IconButton(
            onPressed: () => widget.onToggleCollapse.call(widget.fixedExpense.id),
            icon: Icon(
                widget.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: AppColors.primarySecondText
            )
        ),
      ],
    );
  }

  Widget _amountRow() {
    return GrayBox(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Text('Beløb', style: TextStyle(color: AppColors.primarySecondText)),
              Expanded(
                child: NumberEditableField(
                    textAlign: TextAlign.end,
                    initialValue: widget.fixedExpense.amount,
                    onValueChanged: (_) {}
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('kr')
              )
            ],
          ),
        ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _frequency(),
        Divider(color: AppColors.primaryText.withAlpha(50),),
        _nextPayment(),
        Divider(color: AppColors.primaryText.withAlpha(50),),
        _manualPay()
      ],
    );
  }

  Widget _frequency() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Interval'),
        _paymentTypeDropdown()
      ],
    );
  }


  Widget _paymentTypeDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<PaymentType>(
        alignment: Alignment.center,
        dropdownColor: AppColors.white,
        style: TextStyle(color: Colors.black87),
        value: widget.fixedExpense.paymentType,
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
          widget.fixedExpense.paymentType = newValue!;
          _updateItem();
        },
      ),
    );
  }

  Widget _nextPayment() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Næste betaling'),
          _dueDatePicker()
        ],
      ),
    );
  }

  Widget _dueDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: widget.fixedExpense.nextPaymentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            widget.fixedExpense.nextPaymentDate = picked;
            _updateItem();
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.fixedExpense.nextPaymentDate.formatDate()),
          Icon(Icons.arrow_drop_down, color: AppColors.primarySecondText,)
        ],
      ),
    );
  }

  Widget _manualPay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Manuel betaling'),
          SizedBox(
            width: 100,
            child: PremiumBlueButton(
                height: 30,
                text: 'Registrer',
                onTap: () => widget.onManualPay.call(widget.fixedExpense)
            ),
          )
        ],
      ),
    );
  }

  Widget _wrappedIcon() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12)
      ),
      padding: EdgeInsets.all(6),
      child: Icon(Icons.favorite_border, color: AppColors.primary),
    );
  }

  Widget _autoPayIndicator() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.fixedExpense.autoPay = !widget.fixedExpense.autoPay;
          _updateItem();
        });
      },
      child: Icon(
        widget.fixedExpense.autoPay ? Icons.toggle_on : Icons.toggle_off,
        color: widget.fixedExpense.autoPay ? AppColors.primary : Colors.grey.shade600,
        size: 40,
      ),
    );
  }

  void _updateItem() {
    widget.onChanged.call(widget.fixedExpense);
  }
}
