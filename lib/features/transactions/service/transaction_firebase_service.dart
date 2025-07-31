import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/app/network/transaction_api.dart';
import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:riverpod/riverpod.dart';

class TransactionFirebaseService implements TransactionApi {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  TransactionFirebaseService(this._firestore, this._ref);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final householdId = _ref.watch(currentUserProvider).householdId;
    var response = await _getCollection(householdId).get();

    print("Fetched all transactions");
    final transactions = await Future.wait(response.docs.map((doc) {
      return Transaction.fromFirestore(doc);
    }));

    return transactions;
  }

  @override
  Future<void> postTransaction(Transaction transaction) async {
    try {
      final householdId = _ref.watch(currentUserProvider).householdId;
      await _getCollection(householdId).add({
        'user': _firestore.collection('users').doc(transaction.user.id),
        'amount': transaction.amount,
        'category': transaction.category.name,
        'type': transaction.type.name,
        'createdTime': transaction.createdTime ?? FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch(e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> _getCollection(String? householdId) {
    return _firestore
      .collection('households')
      .doc(householdId)
      .collection('transactions');
  }

  
}