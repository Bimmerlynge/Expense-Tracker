import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/transactions/data/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseTransactionRepository implements TransactionRepository {
  final Ref ref;

  FirebaseTransactionRepository({required this.ref});

  @override
  Stream<List<Transaction>> getTransactionsStream() {
    var response = _getCollection()
        .orderBy('transactionTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Transaction.fromFire(doc)).toList(),
        );

    return response;
  }

  @override
  Future<bool> deleteTransactionById(String transactionId) async {
    try {
      await _getCollection().doc(transactionId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> postTransaction(Transaction transaction) async {
    try {
      await _getCollection().add(transaction.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Transaction>> getTransactionsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final snapshot = await _getCollection()
        .where('transactionTime', isGreaterThanOrEqualTo: start)
        .where('transactionTime', isLessThan: end)
        .get();

    return snapshot.docs.map((doc) => Transaction.fromFire(doc)).toList();
  }

  CollectionReference<Map<String, dynamic>> _getCollection() {
    final householdId = ref.watch(currentUserProvider).householdId;
    return ref
        .read(firestoreProvider)
        .collection('households')
        .doc(householdId)
        .collection('transactions');
  }
}
