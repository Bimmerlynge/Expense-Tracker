import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String? id;
  final String name;
  String? iconName;
  bool? isDefault;

  Category({
    this.id,
    required this.name,
    this.iconName,
    this.isDefault
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Category(
      id: doc.id,
      name: data['name'],
      iconName: data['icon'] as String?,
      isDefault: data['isDefault'] as bool,
    );
  }

  factory Category.fixedExpense() {
    return Category(
        name: 'Faste udgifter',
        isDefault: false
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name' : name,
      'isDefault' : isDefault
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    bool? isDefault
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      isDefault: isDefault ?? this.isDefault
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Category &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
