import 'package:expense_tracker/domain/category.dart';

class LineItem {
  int? id;
  final String name;
  double price;
  Category? category;
  double? discount;

  LineItem({this.id, required this.name, required this.price, this.category, this.discount});

  factory LineItem.toDomain(Map map, int id, Category? defaultCategory) {
    return LineItem(
        id: id,
        name: map['name'],
        price: map['amount'].toDouble() ?? 0.0,
        category: defaultCategory
    );
  }
}