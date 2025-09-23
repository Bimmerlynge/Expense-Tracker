import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/app/repository/transaction_api.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionFirebaseService implements TransactionApi {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  TransactionFirebaseService(this._firestore, this._ref);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    var response = await _getCollection().get();

    debugPrint("Fetched all transactions");
    final transactions = await Future.wait(
      response.docs.map((doc) {
        return Transaction.fromFirestore(doc);
      }),
    );

    return transactions;
  }

  @override
  Future<void> postTransaction(Transaction transaction) async {
    try {
      await _getCollection().add({
        'user': {'id': transaction.user.id, 'name': transaction.user.name},
        'amount': transaction.amount,
        'category': transaction.category.name,
        'type': transaction.type.name,
        'createdTime': DateTime.now(),
        'transactionTime': transaction.transactionTime,
        'description': transaction.description
      });
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> _getCollection() {
    final householdId = _ref.watch(currentUserProvider).householdId;
    return _firestore
        .collection('households')
        .doc(householdId)
        .collection('transactions');
  }

  @override
  Stream<List<Transaction>> getTransactionsStream() {
    var response = _getCollection()
        .orderBy('transactionTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) =>
                  Transaction.fromFire(doc))
                  .toList()
    );

    return response;
  }

  @override
  Stream<List<Transaction>> getTransactionStreamInRange(DateTime start, DateTime end) {
    return _getCollection()
      .where('transactionTime', isGreaterThanOrEqualTo: start)
      .where('transactionTime', isLessThan: end)
      .orderBy('transactionTime', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => Transaction.fromFire(doc))
            .toList();
    });
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _getCollection().doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
