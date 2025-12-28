import 'package:expense_tracker/domain/person.dart';

class BalanceTotal {
  final Person person;
  final double income;
  final double expense;

  BalanceTotal({
    required this.person,
    required this.income,
    required this.expense,
  });
}
