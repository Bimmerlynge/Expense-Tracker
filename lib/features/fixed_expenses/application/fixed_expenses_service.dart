import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/extensions/fixed_expense_extensions.dart';
import 'package:expense_tracker/features/common/data/shared_prefs_repository.dart';
import 'package:expense_tracker/features/fixed_expenses/data/fixed_expense_repository.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fixedExpenseServiceProvider = Provider<FixedExpenseService>((ref) {
  return FixedExpenseService(
      transactionService: ref.read(transactionServiceProvider),
      fixedExpenseRepository: ref.read(fixedExpenseRepositoryProvider),
      sharedPrefsRepository: ref.read(sharedPrefsRepositoryProvider),
      ref: ref
  );
});

class FixedExpenseService {
  final TransactionService transactionService;
  final FixedExpenseRepository fixedExpenseRepository;
  final SharedPrefsRepository sharedPrefsRepository;
  final Ref ref;

  FixedExpenseService({
    required this.transactionService,
    required this.fixedExpenseRepository,
    required this.sharedPrefsRepository,
    required this.ref
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
    final collapsed = sharedPrefsRepository.loadCollapsedFixedExpenses();

    if (collapsed.contains(expenseId)) {
      collapsed.remove(expenseId);
    } else {
      collapsed.add(expenseId);
    }

    await sharedPrefsRepository.updateCollapsedFixedExpenses(collapsed);
  }

  List<String> getCollapsedFixedExpenses() {
    return sharedPrefsRepository.loadCollapsedFixedExpenses();
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
    return _isCurrentMonth(expense) &&
            _isAutoPayEnabled(expense);
  }

  bool _isCurrentMonth(FixedExpense expense) {
    final currentMonth = DateTime.now().month;
    return expense.nextPaymentDate.month == currentMonth;
  }

  bool _isAutoPayEnabled(FixedExpense expense) => expense.autoPay;
}