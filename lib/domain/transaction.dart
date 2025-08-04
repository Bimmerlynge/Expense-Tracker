import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';

enum TransactionType { expense, income }

class Transaction {
  String? id;
  Person user;
  DateTime? createdTime;
  double amount;
  Category category;
  TransactionType type;

  Transaction({
    this.id,
    required this.user,
    this.createdTime,
    required this.amount,
    required this.category,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json, String id) {
    return Transaction(
      id: id,
      user: json['user'],
      amount: json['amount'] as double,
      category: json['category'] as Category,
      type: json['type'] as TransactionType,
    );
  }

  static Future<Transaction> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final userDoc = await data['user'].get();
    final user = Person.fromJson(userDoc.data() as Map<String, dynamic>);

    return Transaction(
      id: doc.id,
      user: user,
      amount: (data['amount'] as num).toDouble(),
      category: Category(name: data['category'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${data['type']}',
      ),
      createdTime: (data['createdTime'] as Timestamp).toDate(),
    );
  }

  factory Transaction.fromFire(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Transaction(
      id: doc.id,
      user: Person(id: data['user']['id'], name: data['user']['name']),
      amount: (data['amount'] as num).toDouble(),
      category: Category(name: data['category'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${data['type']}',
      ),
      createdTime: (data['createdTime'] as Timestamp).toDate(),
    );
  }
}
