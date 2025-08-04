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

  @override
  List<Object?> get props => [id];
}
