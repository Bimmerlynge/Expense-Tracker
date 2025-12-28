import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/common/widget/popup_widget.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/add_fixed_expense/add_fixed_expense_popup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/config/theme/app_colors.dart';

class AddFixedExpensePopup extends ConsumerStatefulWidget {
  const AddFixedExpensePopup({super.key});

  @override
  ConsumerState<AddFixedExpensePopup> createState() =>
      _AddFixedExpensePopupState();
}

class _AddFixedExpensePopupState extends ConsumerState<AddFixedExpensePopup> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(
      addFixedExpensePopupControllerProvider.notifier,
    );
    final expense = ref.watch(addFixedExpensePopupControllerProvider);

    return PopupWidget(
      popupIcon: const Icon(Icons.new_releases_outlined),
      bodyContent: _buildDialogContent(controller, expense),
      onConfirm: () => _handleConfirm(controller),
      confirmText: "Opret",
      headerTitle: "Ny fast udgift",
    );
  }

  Future<void> _handleConfirm(AddFixedExpensePopupController controller) async {
    final success = await controller.createFixedExpense();

    if (success) {
      ToastService.showSuccessToast('Fast udgift oprettet!');
    } else {
      ToastService.showErrorToast('Fejl ved oprettelse af fast udgift.');
    }
  }

  Widget _buildDialogContent(
    AddFixedExpensePopupController controller,
    FixedExpense expense,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitleRow(controller, expense),
        const SizedBox(height: 16),
        _buildAmountRow(controller, expense),
        const SizedBox(height: 24),
        _buildTypeRow(controller, expense),
        const SizedBox(height: 24),
        _buildDateRow(controller, expense),
      ],
    );
  }

  Widget _buildTitleRow(
    AddFixedExpensePopupController controller,
    FixedExpense expense,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Titel'),
        ),
        inputContainer(
          TextFormField(
            initialValue: expense.title,
            style: TextStyle(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
            onChanged: controller.updateTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(
    AddFixedExpensePopupController controller,
    FixedExpense expense,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Beløb'),
        ),
        inputContainer(
          TextFormField(
            initialValue: expense.amount.toString(),
            style: TextStyle(color: AppColors.onPrimary),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            onChanged: (val) =>
                controller.updateAmount(double.tryParse(val) ?? 0),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeRow(
    AddFixedExpensePopupController controller,
    FixedExpense expense,
  ) {
    return inputContainer(
      DropdownButtonHideUnderline(
        child: DropdownButton<PaymentType>(
          alignment: Alignment.center,
          dropdownColor: AppColors.primary,
          style: TextStyle(color: AppColors.primaryText, fontSize: 16),
          value: expense.paymentType,
          items: const [
            DropdownMenuItem(
              value: PaymentType.monthly,
              child: Text('Månedlig'),
            ),
            DropdownMenuItem(
              value: PaymentType.twoMonthly,
              child: Text('Hver 2. måned'),
            ),
            DropdownMenuItem(
              value: PaymentType.quarterly,
              child: Text('Kvartalsvis'),
            ),
          ],
          onChanged: controller.updatePaymentType,
        ),
      ),
    );
  }

  Widget _buildDateRow(
    AddFixedExpensePopupController controller,
    FixedExpense expense,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text('Betalings dato'),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePickerDialog(
              context: context,
              initialDate: expense.nextPaymentDate,
              minDate: DateTime(2000),
              maxDate: DateTime(2100),
            );
            if (picked != null) controller.updateNextPaymentDate(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryText),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('dd/MM/yyyy').format(expense.nextPaymentDate),
              style: TTextTheme.mainTheme.labelMedium,
            ),
          ),
        ),
      ],
    );
  }
}
