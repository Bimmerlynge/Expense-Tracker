import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final String id;
  final String name;
  final String? householdId;

  const Person({required this.id, required this.name, this.householdId});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json['userId'],
    name: json['name'],
    householdId: json['householdId'],
  );

  factory Person.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Person(id: data['userId'], name: data['name'] as String);
  }

  @override
  List<Object?> get props => [id];
}
