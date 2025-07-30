import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:expense_tracker/app/network/transaction_api.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:riverpod/riverpod.dart';

class TransactionFirebaseService implements TransactionApi {
  final FirebaseFirestore _firestore;
  final Person _currentUser;

  TransactionFirebaseService(this._firestore, this._currentUser);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    var response = await _firestore
        .collection('households')
        .doc(_currentUser.householdId)
        .collection('transactions')
        .get();

    final transactions = await Future.wait(response.docs.map((doc) {
      return Transaction.fromFirestore(doc);
    }));

    return transactions;
  }

  @override
  Future<void> postTransaction(Transaction transaction) async {
    await _firestore
        .collection('households')
        .doc(_currentUser.householdId)
        .collection('transactions')
        .add({
      'user': _firestore.collection('users').doc(transaction.user.id),
      'amount': transaction.amount,
      'category': transaction.category.name,
      'type': transaction.type.name,
      'createdTime': transaction.createdTime ?? FieldValue.serverTimestamp(),
    });
  }

  
}