import 'package:expense_tracker/features/fixed_expenses/application/fixed_expenses_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collapsed_fixed_expenses_controller.g.dart';

@riverpod
class CollapsedFixedExpensesController extends _$CollapsedFixedExpensesController {

  @override
  List<String> build() {
    final service = ref.read(fixedExpenseServiceProvider);
    return service.getCollapsedFixedExpenses();
  }

  Future<void> toggle(String expenseId) async {
    final service = ref.read(fixedExpenseServiceProvider);
    await service.toggleCollapsedFixedExpense(expenseId);

    state = service.getCollapsedFixedExpenses();
  }
}