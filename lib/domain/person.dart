import 'package:equatable/equatable.dart';

class Person extends Equatable {
  String id;
  String name;
  String? householdId;

  Person({required this.id, required this.name, this.householdId});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json['userId'],
    name: json['name'],
    householdId: json['householdId']
  );

  @override
  List<Object?> get props => [id];


}