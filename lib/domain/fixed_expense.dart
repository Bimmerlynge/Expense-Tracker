import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentType { monthly, twoMonthly, quarterly }

class FixedExpense {
  final String id;
  final String title;
  double amount;
  PaymentType paymentType;
  bool hasBeenPaid;
  DateTime nextPaymentDate;
  DateTime lastPaymentDate;
  bool autoPay;

  FixedExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paymentType,
    required this.hasBeenPaid,
    required this.nextPaymentDate,
    required this.lastPaymentDate,
    required this.autoPay
  });

  factory FixedExpense.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return FixedExpense(
      id: snapshot.id,
      title: data['title'],
      amount: (data['amount'] as num).toDouble(),
      paymentType: PaymentType.values.firstWhere(
          (type) => type.toString() == 'PaymentType.${data['paymentType']}'
      ),
      hasBeenPaid: data['hasBeenPaid'],
      autoPay: data['autoPay'],
      nextPaymentDate: (data['nextPaymentDate'] as Timestamp).toDate(),
      lastPaymentDate: (data['lastPaymentDate'] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount,
      'paymentType': paymentType.name,
      'hasBeenPaid': hasBeenPaid,
      'autoPay': autoPay,
      'nextPaymentDate': Timestamp.fromDate(nextPaymentDate),
      'lastPaymentDate': Timestamp.fromDate(lastPaymentDate),
    };
  }

  DateTime getNextPaymentDate() {
    switch (paymentType) {
      case PaymentType.monthly:
        return _addMonths(nextPaymentDate, 1);

      case PaymentType.twoMonthly:
        return _addMonths(nextPaymentDate, 2);

      case PaymentType.quarterly:
        return _addMonths(nextPaymentDate, 3);
    }
  }

  DateTime _addMonths(DateTime date, int monthsToAdd) {
    final newYear = date.year + ((date.month + monthsToAdd - 1) ~/ 12);
    final newMonth = ((date.month + monthsToAdd - 1) % 12) + 1;
    final lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = date.day <= lastDayOfMonth ? date.day : lastDayOfMonth;

    return DateTime(newYear, newMonth, newDay);
  }
}
