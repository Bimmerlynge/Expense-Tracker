import 'person.dart';

class Goal {
  String? id;
  String title;
  Person creator;
  bool isShared;
  double goalAmount;
  double currentAmount;
  String? uri;

  Goal({
    this.id,
    required this.title,
    required this.creator,
    required this.isShared,
    required this.goalAmount,
    required this.currentAmount,
    this.uri
  });


}