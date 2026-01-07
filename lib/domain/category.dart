import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String? id;
  final String name;
  String? iconName;
  bool? isDefault;
  Color? color;

  Category({
    this.id,
    required this.name,
    this.iconName,
    this.isDefault,
    this.color,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Category(
      id: doc.id,
      name: data['name'],
      iconName: data['icon'] as String?,
      isDefault: data['isDefault'] as bool,
      color: data['color'] != null ? Color(data['color'] as int) : null,
    );
  }

  factory Category.fixedExpense() {
    return Category(name: 'Faste udgifter', isDefault: false);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'isDefault': isDefault, 'color': color?.toARGB32()};
  }

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    bool? isDefault,
    Color? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      isDefault: isDefault ?? this.isDefault,
      color: color ?? this.color,
    );
  }

  bool isFixedExpense() {
    return name == 'Faste udgifter';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return name;
  }
}
