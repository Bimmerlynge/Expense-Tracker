import 'dart:async';

import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/service/fixed_expense_firebase_service.dart';
import 'package:expense_tracker/features/transactions/service/transaction_firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseViewModel extends StateNotifier<AsyncValue<List<FixedExpense>>> {
  final FixedExpenseFirebaseService _fixedExpenseFirebaseService;
  final TransactionFirebaseService _transactionFirebaseService;
  final Ref _ref;
  late final Stream<List<FixedExpense>> _fixedExpensesStream;
  late final StreamSubscription _subscription;

  final _dataLoadedController = StreamController<List<FixedExpense>>.broadcast();
  Stream<void> get onDataLoaded => _dataLoadedController.stream;

  FixedExpenseViewModel(this._fixedExpenseFirebaseService, this._transactionFirebaseService, this._ref) : super(const AsyncValue.loading()) {
    _fixedExpensesStream = _fixedExpenseFirebaseService.getFixedExpensesStream();

    _subscription = _fixedExpensesStream.listen(
        (fixedExpenses) {
          state = AsyncValue.data(fixedExpenses);
          _dataLoadedController.add(fixedExpenses);
        },
      onError: (error, stack) => state = AsyncValue.error(error, stack)
    );
  }

  Future<void> updateFixedExpense(FixedExpense updatedFixedExpense) async {
    await _fixedExpenseFirebaseService.updateFixedExpense(updatedFixedExpense);
  }

  Future<String> addFixedExpense(FixedExpense newFixedExpense) async {
    return await _fixedExpenseFirebaseService.addFixedExpense(newFixedExpense);
  }

  Future<void> registerAutoPayExpenses() async {
    final payments = _getPaymentsToPay();
    if (payments.isEmpty) return;
    
    final currentUser = _ref.read(currentUserProvider);

    for (var expense in payments) {
      final transaction = _createTransaction(expense, currentUser);
      await _transactionFirebaseService.postTransaction(transaction);

      expense.lastPaymentDate = expense.nextPaymentDate;
      expense.nextPaymentDate = expense.getNextPaymentDate();

      updateFixedExpense(expense);
    }
  }

  Future<void> registerExpense(FixedExpense expense) async {
    final currentUser = _ref.read(currentUserProvider);

    final transaction = _createTransaction(expense, currentUser);
    await _transactionFirebaseService.postTransaction(transaction);

    expense.lastPaymentDate = expense.nextPaymentDate;
    expense.nextPaymentDate = expense.getNextPaymentDate();

    updateFixedExpense(expense);
  }
  
  Transaction _createTransaction(FixedExpense expense, Person user) {
    return Transaction(
        user: user, 
        amount: expense.amount, 
        category: Category(name: 'Faste udgifter'),
        type: TransactionType.expense,
        transactionTime: expense.nextPaymentDate,
        description: expense.title
    );
  }

  List<FixedExpense> _getPaymentsToPay() {
    return state.value!.where((expense) =>
        _isCurrentMonth(expense) &&
        _isAutoPayEnabled(expense)
    ).toList();
  }

  bool _isCurrentMonth(FixedExpense expense) {
    final currentMonth = DateTime.now().month;
    return expense.nextPaymentDate.month == currentMonth;
  }

  bool _isAutoPayEnabled(FixedExpense expense) => expense.autoPay;

  @override
  void dispose() {
    _subscription.cancel();
    _dataLoadedController.close();
    super.dispose();
  }
}