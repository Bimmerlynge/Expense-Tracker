import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/text_editable_field.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/app/shared/widgets/white_box.dart';
import 'package:expense_tracker/design_system/components/dropdown/payment_type_dropdown.dart';
import 'package:expense_tracker/design_system/primitives/labelled_field.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button_inverted.dart';
import 'package:expense_tracker/design_system/modals/app_alert_dialog.dart';
import 'package:expense_tracker/design_system/primitives/number_editable_field.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/extensions/date_utils_extensions.dart';
import 'package:expense_tracker/features/fixed_expenses/presentation/add_fixed_expense/add_fixed_expense_popup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateFixedExpenseModal extends ConsumerStatefulWidget {
  const CreateFixedExpenseModal({super.key});

  @override
  ConsumerState<CreateFixedExpenseModal> createState() => _CreateFixedExpenseModalState();
}

class _CreateFixedExpenseModalState extends ConsumerState<CreateFixedExpenseModal> {

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(addFixedExpensePopupControllerProvider.notifier);
    final fixedExpense = ref.watch(addFixedExpensePopupControllerProvider);

    return AppAlertDialog(
        iconData: Icons.new_releases_outlined,
        title: "Ny fast udgift",
        content: _content(controller, fixedExpense),
        actions: _actions(controller)
    );
  }

  Widget _content(AddFixedExpensePopupController controller, FixedExpense fixedExpense) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _title(controller),
        SizedBox(height: 8),
        _amount(controller),
        SizedBox(height: 8),
        _frequency(controller, fixedExpense),
        SizedBox(height: 8),
        _nextPaymentDate(controller, fixedExpense)
      ],
    );
  }

  Widget _title(AddFixedExpensePopupController controller) {
    return LabelledField(
        label: 'Titel',
        child: WhiteBox(
          borderRadius: 25,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: TextEditableField(
                initialValue: "",
                onValueChanged: (value) {
                  controller.updateTitle(value);
                },
                textAlign: TextAlign.center,
            ),
          ),
        )
    );
  }

  Widget _amount(AddFixedExpensePopupController controller) {
    return LabelledField(
        label: 'Beløb',
        child: WhiteBox(
            borderRadius: 25,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: NumberEditableField(
                        textAlign: TextAlign.end,
                        initialValue: 0.0,
                        onValueChanged: (val) {
                          controller.updateAmount(val);
                        }
                    ),
                  ),
                  Text('kr', style: TextStyle(color: Colors.black87),)
                ],
              ),
            )
        )
    );
  }

  Widget _frequency(AddFixedExpensePopupController controller, FixedExpense fixedExpense) {
    return LabelledField(
        label: "Frekvens",
        child: WhiteBox(
          borderRadius: 25,
          child: SizedBox(
            height: 35,
            child: Row(
              children: [
                SizedBox(width: 12),
                Icon(Icons.date_range, color: AppColors.primary),
                Spacer(),
                PaymentTypeDropdown(
                    value: fixedExpense.paymentType,
                    onChanged: (val) {
                      controller.updatePaymentType(val);
                    }
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _nextPaymentDate(AddFixedExpensePopupController controller, FixedExpense fixedExpense) {
    return LabelledField(
        label: "Betalingsdato",
        child: WhiteBox(
            borderRadius: 25,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                  Spacer(),
                  _dueDatePicker(controller, fixedExpense)
                ],
              ),
            )
        )
    );
  }

  Widget _dueDatePicker(AddFixedExpensePopupController controller, FixedExpense fixedExpense) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: fixedExpense.nextPaymentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            controller.updateNextPaymentDate(picked);
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fixedExpense.nextPaymentDate.formatDate(), style: TextStyle(color: Colors.black87),),
          Icon(Icons.arrow_drop_down, color: AppColors.primarySecondText,)
        ],
      ),
    );
  }

  Widget _actions(AddFixedExpensePopupController controller) {
    return Row(
      children: [
        Expanded(
          child: PremiumBlueButtonInverted(
              height: 30,
              text: 'Fortryd',
              onTap: () => Navigator.of(context).pop(false)
          ),
        ),
        SizedBox(width: 16,),
        Expanded(
            child: PremiumBlueButton(
              height: 30,
              text: 'Opret',
              onTap: () => _onCreate(controller),
              linearBegin: Alignment.topLeft,
              linearEnd: Alignment.bottomRight,
            )
        )
      ],
    );
  }

  void _onCreate(AddFixedExpensePopupController controller) async {
    final success = await controller.createFixedExpense();

    if (success) {
      ToastService.showSuccessToast('Fast udgift oprettet!');

      if(mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastService.showErrorToast('Fejl ved oprettelse af fast udgift.');
    }
  }
}
