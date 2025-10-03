import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';

enum TransactionType { expense, income }

class Transaction {
  String? id;
  Person user;
  DateTime? createdTime;
  DateTime? transactionTime;
  double amount;
  Category category;
  TransactionType type;
  String? description;

  Transaction({
    this.id,
    required this.user,
    this.createdTime,
    this.transactionTime,
    required this.amount,
    required this.category,
    required this.type,
    this.description
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
      createdTime: (data['createdTime'] as DateTime),
      transactionTime: (data['transactionTime'] as DateTime)
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
        (type) => type.toString() == 'TransactionType.${data['type']}',
      ),
      createdTime: (data['createdTime'] as Timestamp).toDate(),
      transactionTime: (data['transactionTime'] as Timestamp).toDate(),
      description: data['description']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user': {'id': user.id, 'name': user.name},
      'amount': amount,
      'category': category.name,
      'type': type.name,
      'createdTime': DateTime.now(),
      'transactionTime': transactionTime,
      'description': description,
    };
  }
}
