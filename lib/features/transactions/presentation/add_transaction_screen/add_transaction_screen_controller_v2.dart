import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/categories/providers/default_category_provider.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:expense_tracker/features/transactions/providers/add_transaction_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_transaction_screen_controller_v2.g.dart';

@riverpod
class AddTransactionScreenControllerV2 extends _$AddTransactionScreenControllerV2 {
  @override
  Transaction build() {
    return _initTransaction();
  }

  Transaction _initTransaction() {
    final user = ref.read(currentUserProvider);

    ref.read(selectedPersonProvider.notifier).state = user;
    ref.read(selectedTypeProvider.notifier).state = TransactionType.expense;

    return Transaction(
        user: user,
        transactionTime: DateTime.now(),
        amount: 0.0,
        category: ref.watch(defaultCategoryProvider),
        type: TransactionType.expense,
        description: ""
    );
  }

  Future<void> createTransactionV2() async {
    _validateAmount();
    await ref.read(transactionServiceProvider).createTransaction(state);
    state = _initTransaction();
  }

  void _validateAmount() {
    if (state.amount <= 0) {
      throw ArgumentError('Beløb kan ikke være 0 eller mindre');
    }
  }


  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void updateCategory(Category category) {
    state = state.copyWith(category: category);
  }

  void updatePerson(Person person) {
    state = state.copyWith(person: person);
  }

  void updateType(TransactionType type) {
    state = state.copyWith(type: type);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

}