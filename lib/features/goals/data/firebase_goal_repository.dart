import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/goal.dart';
import 'package:expense_tracker/features/goals/data/goal_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseGoalRepository implements GoalRepository {
  Ref ref;

  FirebaseGoalRepository({required this.ref});

  @override
  Future<bool> createGoal(Goal goal) async {
    try {
      await _getCollection().add(goal.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<Goal>> getGoalsStream() {
    return _getCollection().snapshots().map(
        (snapshots) =>
            snapshots.docs.map(
                (doc) => Goal.fromFirestore(doc)
            ).toList()
    );
  }

  @override
  Future<bool> removeGoal(String goalId) {
    // TODO: implement removeGoal
    throw UnimplementedError();
  }

  @override
  Future<bool> updateGoal(Goal goal) async {
    try {
      await _getCollection()
          .doc(goal.id)
          .update(goal.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  CollectionReference<Map<String, dynamic>> _getCollection() {
    final householdId = ref.read(currentUserProvider).householdId;
    return ref.read(firestoreProvider)
        .collection('households')
        .doc(householdId)
        .collection('saving_goals');
  }
}