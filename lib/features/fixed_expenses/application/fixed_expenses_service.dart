import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/extensions/fixed_expense_extensions.dart';
import 'package:expense_tracker/features/common/application/local_storage_service.dart';
import 'package:expense_tracker/features/fixed_expenses/data/fixed_expense_repository.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fixedExpenseServiceProvider = Provider<FixedExpenseService>((ref) {
  return FixedExpenseService(
    transactionService: ref.read(transactionServiceProvider),
    localStorageService: ref.read(localStorageService),
    fixedExpenseRepository: ref.read(fixedExpenseRepositoryProvider),
    ref: ref,
  );
});

class FixedExpenseService {
  final TransactionService transactionService;
  final LocalStorageService localStorageService;
  final FixedExpenseRepository fixedExpenseRepository;
  final Ref ref;

  FixedExpenseService({
    required this.transactionService,
    required this.localStorageService,
    required this.fixedExpenseRepository,
    required this.ref,
  });

  Stream<List<FixedExpense>> getAllFixedExpensesStream() {
    return fixedExpenseRepository.getFixedExpensesStream();
  }

  Future<bool> createFixedExpense(FixedExpense newFixedExpense) async {
    return await fixedExpenseRepository.addFixedExpense(newFixedExpense);
  }

  Future<void> updateFixedExpense(FixedExpense expense) async {
    await fixedExpenseRepository.updateFixedExpense(expense);

    if (_paymentIsDue(expense)) {
      await registerAutoPayFixedExpense(expense);
    }
  }

  Future<void> toggleCollapsedFixedExpense(String expenseId) async {
    await localStorageService.toggleCollapsedFixedExpense(expenseId);
  }

  List<String> getCollapsedFixedExpenses() {
    return localStorageService.getCollapsedFixedExpenses();
  }

  void registerAutoPayFixedExpenses(List<FixedExpense> expenses) {
    for (var expense in expenses) {
      if (!_paymentIsDue(expense)) continue;
      registerAutoPayFixedExpense(expense);
    }
  }

  Future<void> registerAutoPayFixedExpense(FixedExpense expense) async {
    final currentUser = ref.read(currentUserProvider);

    final transaction = expense.toTransaction(currentUser);
    await transactionService.createTransaction(transaction);

    expense.lastPaymentDate = expense.nextPaymentDate;
    expense.nextPaymentDate = expense.getNextPaymentDate();

    updateFixedExpense(expense);
  }

  bool _paymentIsDue(FixedExpense expense) {
    return _isCurrentMonth(expense) && _isAutoPayEnabled(expense);
  }

  bool _isCurrentMonth(FixedExpense expense) {
    final currentMonth = DateTime.now().month;
    return expense.nextPaymentDate.month == currentMonth;
  }

  bool _isAutoPayEnabled(FixedExpense expense) => expense.autoPay;
}
