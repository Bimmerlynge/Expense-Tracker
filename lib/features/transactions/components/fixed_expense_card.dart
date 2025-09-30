import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/transactions/providers/fixed_expense_view_model_provider.dart';
import 'package:expense_tracker/features/transactions/service/fixed_expenses_expanded_card_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FixedExpenseCard extends ConsumerStatefulWidget {
  final FixedExpense expense;
  final bool initiallyExpanded;

  const FixedExpenseCard({super.key, required this.expense, this.initiallyExpanded = true});

  @override
  ConsumerState<FixedExpenseCard> createState() => _FixedExpenseCardState();
}

class _FixedExpenseCardState extends ConsumerState<FixedExpenseCard> {
  late final TextEditingController _amountController;
  late final FixedExpenseCollapsedCardService _collapsedService;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _amountController = TextEditingController(
      text: widget.expense.amount.toStringAsFixed(2),
    );

    _collapsedService = ref.read(fixedExpenseCollapsedCardProvider);
    _loadExpandedState();
  }

  void _loadExpandedState() {
    final collapsedList = _collapsedService.loadExpanded();

    setState(() {
      _isExpanded = !collapsedList.contains(widget.expense.id);
    });
  }

  void _toggleExpanded() async {
    await _collapsedService.toggleCollapse(widget.expense.id);
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      color: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_isExpanded) _buildBody()
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: _toggleExpanded,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          borderRadius: _isExpanded
              ? const BorderRadius.vertical(top: Radius.circular(12))
              : BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.expense.title,
              style: TTextTheme.mainTheme.labelMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
            Row(
              children: [
                Text(
                  'Automatisk',
                  style: TTextTheme.mainTheme.labelMedium?.copyWith(
                      color: AppColors.primary
                  ),
                ),
                SizedBox(width: 4),
                _autoPayIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _amount(),
          _interval(),
          SizedBox(height: 8),
          _dueDate(),
          SizedBox(height: 8),
          _manuelPay(),
        ],
      ),
    );
  }

  Widget _amount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _label('Beløb'),
        IntrinsicWidth(
          child: TextField(
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: true,
            ),
            controller: _amountController,
            style: TTextTheme.mainTheme.labelMedium,
            onTap: () {
              _amountController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _amountController.text.length
              );
            },
            onSubmitted: (value) {
              widget.expense.amount = double.parse(value);
              _updateItem(widget.expense);
              FocusScope.of(context).unfocus();
            }
          ),
        ),
      ],
    );
  }

  void _updateItem(FixedExpense updated) {
    ref.read(fixedExpenseViewModelProvider.notifier)
        .updateFixedExpense(updated);
  }

  Widget _interval() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_label('Interval'), _paymentTypeDropdown()],
    );
  }

  Widget _paymentTypeDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<PaymentType>(
        alignment: Alignment.center,
        dropdownColor: AppColors.primary,
        style: TextStyle(color: AppColors.primaryText, fontSize: 16),
        value: widget.expense.paymentType,
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
          widget.expense.paymentType = newValue!;
          _updateItem(widget.expense);
        },
      ),
    );
  }

  Widget _dueDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_label('Næste betaling'), _dueDatePicker()],
    );
  }

  Widget _dueDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePickerDialog(
          context: context,
          initialDate: widget.expense.nextPaymentDate,
          minDate: DateTime(2000),
          maxDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            widget.expense.nextPaymentDate = picked;
            _updateItem(widget.expense);
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
          DateFormat('dd/MM/yyyy').format(widget.expense.nextPaymentDate),

          style: TTextTheme.mainTheme.labelMedium,
        ),
      ),
    );
  }

  Widget _manuelPay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _label('Manuel betaling'),
        ElevatedButton(
            onPressed: _registerManuelPay,
            child: Text('Registrer'),
        )
      ],
    );
  }

  Future<void> _registerManuelPay() async {
    final vm = ref.read(fixedExpenseViewModelProvider.notifier);
    await vm.registerExpense(widget.expense);

    ToastService.showSuccessToast(context, 'Payment was successful');
  }

  Text _label(String title) {
    return Text(title, style: TTextTheme.mainTheme.labelMedium);
  }

  Widget _autoPayIndicator() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.expense.autoPay = !widget.expense.autoPay;
          _updateItem(widget.expense);
        });
      },
      child: Icon(
        widget.expense.autoPay ? Icons.toggle_on : Icons.toggle_off,
        color: widget.expense.autoPay ? Colors.green : Colors.grey.shade600,
        size: 32,
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
