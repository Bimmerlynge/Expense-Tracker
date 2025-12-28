import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:expense_tracker/features/fixed_expenses/data/fixed_expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseFixedExpensesRepository implements FixedExpenseRepository {
  final Ref ref;

  FirebaseFixedExpensesRepository({required this.ref});

  @override
  Stream<List<FixedExpense>> getFixedExpensesStream() {
    final response = _getCollection().snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => FixedExpense.fromFirestore(doc)).toList(),
    );

    return response;
  }

  @override
  Future<bool> addFixedExpense(FixedExpense fixedExpense) async {
    try {
      await _getCollection().add(fixedExpense.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateFixedExpense(FixedExpense fixedExpense) async {
    await _getCollection()
        .doc(fixedExpense.id)
        .update(fixedExpense.toFirestore());
  }

  CollectionReference<Map<String, dynamic>> _getCollection() {
    final userId = ref.watch(currentUserProvider).id;
    return ref
        .read(firestoreProvider)
        .collection('users')
        .doc(userId)
        .collection('fixed-expenses');
  }
}
