import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/app/repository/fixed_expense_api.dart';
import 'package:expense_tracker/domain/fixed_expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FixedExpenseFirebaseService implements FixedExpenseApi {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  FixedExpenseFirebaseService({
    required FirebaseFirestore firestore,
    required Ref ref,
  }) : _firestore = firestore,
       _ref = ref;

  @override
  Stream<List<FixedExpense>> getFixedExpensesStream() {
    var response = _getCollection()
        .snapshots()
        .map((snapshot) => snapshot.docs
          .map((doc) => FixedExpense.fromFirestore(doc))
          .toList()
    );

    return response;
  }

  @override
  Future<void> updateFixedExpense(FixedExpense fixedExpense) async {
    await _getCollection()
        .doc(fixedExpense.id)
        .update(fixedExpense.toFirestore());
  }

  CollectionReference<Map<String, dynamic>> _getCollection() {
    final userId = _ref.watch(currentUserProvider).id;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('fixed-expenses');
  }
}
