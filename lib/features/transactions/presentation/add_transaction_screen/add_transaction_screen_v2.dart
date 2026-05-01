import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/components/labelled_field.dart';
import 'package:expense_tracker/app/shared/components/number_editable_field.dart';
import 'package:expense_tracker/app/shared/components/text_editable_field.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/app/shared/widgets/app_bar_gradiant.dart';
import 'package:expense_tracker/app/shared/widgets/gray_box.dart';
import 'package:expense_tracker/design_system/components/buttons/premium_blue_button.dart';
import 'package:expense_tracker/app/shared/widgets/white_box.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen/add_transaction_screen_controller_v2.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen/widget/category_input_row.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen/widget/date_input_row.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen/widget/person_input_row.dart';
import 'package:expense_tracker/features/transactions/presentation/add_transaction_screen/widget/type_input_row.dart';
import 'package:expense_tracker/features/transactions/presentation/camera_screen/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreenV2 extends ConsumerStatefulWidget {
  const AddTransactionScreenV2({super.key});

  @override
  ConsumerState<AddTransactionScreenV2> createState() => _AddTransactionScreenV2State();
}

class _AddTransactionScreenV2State extends ConsumerState<AddTransactionScreenV2> {


  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(addTransactionScreenControllerV2Provider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text("Ny transaktion", style: TextStyle(color: AppColors.white)),
        flexibleSpace: AppBarGradiant(),
      ),
      body: _buildBody(transaction),
    );
  }

  Widget _buildBody(Transaction transaction) {
    return Column(
      children: [
        SizedBox(height: 12,),
        _headerButtons(),
        SizedBox(height: 12,),
        Expanded(child: _form(transaction))
      ],
    );
  }

  Widget _form(Transaction transaction) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 150),
      child: Container(
        margin: EdgeInsets.only(bottom: 12, left: 8, right: 8),
        child: WhiteBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  _amountRow(transaction),
                  SizedBox(height: 16),
                  _dateRow(transaction),
                  SizedBox(height: 16),
                  _categoryRow(transaction),
                  SizedBox(height: 16),
                  _payerRow(transaction),
                  SizedBox(height: 16),
                  _transactionTypeRow(transaction),
                  SizedBox(height: 16),
                  _descriptionRow(transaction),
                  SizedBox(height: 16),
                  _confirmButton()
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _confirmButton() {
    return PremiumBlueButton(
        text: "Tilføj",
        onTap: _createTransaction,
        linearBegin: Alignment.topLeft,
        linearEnd: Alignment.bottomRight
    );
  }
  
  Future<void> _createTransaction() async {
    try {
      await ref.read(addTransactionScreenControllerV2Provider.notifier).createTransactionV2();
      ToastService.showSuccessToast("Transaktionen blev tilføjet!");
    } catch (e) {
      ToastService.showErrorToast("Fejl ved oprettelse af transaktion");
    }
  }

  Widget _headerButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: PremiumBlueButton(
          icon: Icons.camera_alt_rounded,
          text: "Scan kvittering",
          onTap: toCameraScreen,
          linearBegin: Alignment.topLeft,
          linearEnd: Alignment.bottomRight
      ),
    );
  }

  void toCameraScreen() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => CameraScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Widget _amountRow(Transaction transaction) {
    return LabelledField(
        label: "Beløb",
        child: GrayBox(
          alignment: Alignment.centerLeft,
          child: NumberEditableField(
              fontSize: 16,
              textAlign: TextAlign.start,
              initialValue: transaction.amount,
              onValueChanged: (newValue) {
                ref.read(addTransactionScreenControllerV2Provider.notifier).updateAmount(newValue);
              }
          ),
        )
    );
  }

  Widget _dateRow(Transaction transaction) {
    return LabelledField(
        label: "Dato",
        child: GrayBox(
            alignment: Alignment.center,
            child: DateInputRow(
                initialDate: transaction.transactionTime!,
                onChanged: ref.read(addTransactionScreenControllerV2Provider.notifier).updateDate)
        )
    );
  }

  Widget _categoryRow(Transaction transaction) {
    return CategoryInputRow(
      initialValue: transaction.category,
      onCategoryChanged: (newValue)  {
        ref.read(addTransactionScreenControllerV2Provider.notifier).updateCategory(newValue);
      }
    );
  }

  Widget _payerRow(Transaction transaction) {
    return LabelledField(
      label: "Betaler",
      child: PersonInputRow(
        onChanged: (newValue) => ref.read(addTransactionScreenControllerV2Provider.notifier).updatePerson(newValue),
      ),
    );
  }

  Widget _transactionTypeRow(Transaction transaction) {
    return LabelledField(
      label: "Type",
        child: TypeInputRow(
            onChanged: (newValue) => ref.read(addTransactionScreenControllerV2Provider.notifier).updateType(newValue)
        )
    );
  }

  Widget _descriptionRow(Transaction transaction) {
    return LabelledField(
        label: "Beskrivelse",
        child: GrayBox(
            alignment: Alignment.centerLeft,
            child: TextEditableField(
              textAlign: TextAlign.start,
              fontSize: 16,
              initialValue: transaction.description ?? "",
              onValueChanged: (newValue) => ref.read(addTransactionScreenControllerV2Provider.notifier).updateDescription(newValue),
            )
        )
    );
  }
}
