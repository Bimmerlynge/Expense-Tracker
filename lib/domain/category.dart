import 'package:equatable/equatable.dart';

class Category extends Equatable {
  String name;

  Category({required this.name});

  @override
  List<Object?> get props => [name];
}