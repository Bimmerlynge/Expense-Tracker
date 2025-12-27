import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Goal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Goal(
        id: doc.id,
        title: data['title'],
        creator: Person(id: data['creator']['id'], name: data['creator']['name']),
        isShared: data['isShared'],
        goalAmount: data['goalAmount'],
        currentAmount: data['currentAmount'],
        uri: data['imageUrl']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'creator': {'id': creator.id, 'name': creator.name},
      'isShared': isShared,
      'goalAmount': goalAmount,
      'currentAmount': currentAmount,
      'imageUri': uri
    };
  }


  Goal copyWith({
    String? id,
    String? title,
    Person? creator,
    bool? isShared,
    double? goalAmount,
    double? currentAmount,
    String? uri
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      creator: creator ?? this.creator,
      isShared: isShared ?? this.isShared,
      goalAmount: goalAmount ?? this.goalAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      uri: uri ?? this.uri
    );
  }
}