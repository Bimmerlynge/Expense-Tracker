import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String? iconName;
  final bool? isDefault;

  const Category({required this.name, this.iconName, this.isDefault});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Category(
      name: data['name'],
      iconName: data['icon'] as String?,
      isDefault: data['isDefault'] as bool?,
    );
  }

  @override
  List<Object?> get props => [name];
}
