import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/extensions/date_utils_extensions.dart';
import 'package:expense_tracker/features/transactions/domain/discount_item.dart';
import 'package:expense_tracker/features/transactions/domain/line_item.dart';

class Receipt {
  DateTime date;
  List<LineItem> items;
  List<DiscountItem> unresolvedDiscounts;
  Person? user;

  Receipt({this.user, required this.date, required this.items, required this.unresolvedDiscounts});

  factory Receipt.toDomain(Map map) {
    return Receipt(
        date: _mapDate(map['date']),
        items: _mapLineItems(map['items']),
        unresolvedDiscounts: _mapDiscounts(map['discounts'])
    );
  }

  static DateTime _mapDate(String? dateField) {
    try {
      return dateField!.toDateTime();
    } catch (_) {
      return DateTime.now();
    }
  }

  static List<DiscountItem> _mapDiscounts(List discounts) {
    return discounts.asMap().entries.map((entry) => DiscountItem.toDomain(entry.value, entry.key)).toList();
  }

  static List<LineItem> _mapLineItems(List items) {
    return items.asMap().entries.map((entry) => LineItem.toDomain(entry.value, entry.key, Category(name: "Mad"))).toList();
  }

  Receipt copyWith({
    DateTime? date,
    List<LineItem>? items,
    List<DiscountItem>? unresolvedDiscounts,
    Person? user
  }) {
    return Receipt(
        date: date ?? this.date,
        items: items ?? this.items,
        unresolvedDiscounts: unresolvedDiscounts ?? this.unresolvedDiscounts,
        user: user ?? this.user
    );
  }

  LineItem getLineItemById(int id) {
    return items.firstWhere((item) => item.id == id);
  }
  
  void addLineItem(LineItem lineItem) {
    lineItem.id = nextId;
    items.insert(0, lineItem);
  }

  int get nextId {
    if (items.isEmpty) return 1;
    return items.map((e) => e.id!).reduce((a, b) => a > b ? a : b) + 1;
  }

  bool hasItemById(int id) {
    return items.any((e) => e.id == id);
  }
}