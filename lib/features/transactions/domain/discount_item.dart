import 'package:expense_tracker/features/transactions/domain/line_item.dart';

class DiscountItem {
  int id;
  String name;
  double amount;
  LineItem? appliedTo;

  DiscountItem({required this.id, required this.name, required this.amount, this.appliedTo});

  factory DiscountItem.toDomain(Map map, int id) {
    return DiscountItem(
        id: id,
        name: map['name'],
        amount: map['amount'].toDouble() ?? 0.0
    );
  }

  void applyDiscount(LineItem applyTo) {
    appliedTo = applyTo;
  }

  factory DiscountItem.nullObject() {
    return DiscountItem(id: -1, name: "Ingen rabat", amount: 0.0);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiscountItem &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}