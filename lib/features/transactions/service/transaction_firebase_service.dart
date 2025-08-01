import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/app/network/transaction_api.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class TransactionFirebaseService implements TransactionApi {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  TransactionFirebaseService(this._firestore, this._ref);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    var response = await _getCollection().get();

    debugPrint("Fetched all transactions");
    final transactions = await Future.wait(response.docs.map((doc) {
      return Transaction.fromFirestore(doc);
    }));

    return transactions;
  }



  @override
  Future<void> postTransaction(Transaction transaction) async {
    try {
      await _getCollection().add({
        'user': {
          'id': transaction.user.id,
          'name': transaction.user.name
        },
        'amount': transaction.amount,
        'category': transaction.category.name,
        'type': transaction.type.name,
        'createdTime': DateTime.now(),
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
    var response = _getCollection().snapshots()
      .map((snapshot) =>
        snapshot.docs.map((doc) =>
            Transaction.fromFire(doc))
            .toList()
      );
    // TODO: implement getTransactionsStream
    return response;
  }


}