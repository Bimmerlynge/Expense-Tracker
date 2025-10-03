import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/fixed_expenses/application/fixed_expenses_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_fixed_expense_popup_controller.g.dart';

@riverpod
class AddFixedExpensePopupController extends _$AddFixedExpensePopupController {

  @override
  FixedExpense build() {
    return FixedExpense(
        id: '',
        title: '',
        amount: 0,
        paymentType: PaymentType.monthly,
        hasBeenPaid: false,
        nextPaymentDate: DateTime.now(),
        lastPaymentDate: DateTime(1995),
        autoPay: false,
    );
  }

  Future<bool> createFixedExpense() async {
    final success = await ref.read(fixedExpenseServiceProvider)
        .createFixedExpense(state);

    if (!success) {
      return false;
    }

    return true;
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void updatePaymentType(PaymentType? type) {
    state = state.copyWith(paymentType: type);
  }

  void updateNextPaymentDate(DateTime date) {
    state = state.copyWith(nextPaymentDate: date);
  }
}