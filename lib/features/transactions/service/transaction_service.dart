// import 'package:expense_tracker/app/network/api_client.dart';
// import 'package:expense_tracker/app/network/transaction_api.dart';
// import 'package:expense_tracker/domain/transaction.dart';
//
// import '../../../domain/category.dart';
//
// class TransactionService implements TransactionApi {
//   final ApiClient api;
//
//   TransactionService(this.api);
//
//   @override
//   Future<List<Transaction>> getAllTransactions() async {
//     await Future.delayed(Duration(seconds: 2));
//
//     try {
//       var result = await api.get<List<dynamic>>("/transactions");
//       print("result: $result");
//       return _toDomain(result);
//     } catch(e) {
//       print("Error fetching transactions: $e");
//       return [];
//     }
//   }
//
//   List<Transaction> _toDomain(List<dynamic> rawList) {
//     return rawList.map((json) {
//       return Transaction(
//         // id: json['id'] as int?,
//         amount: json['amount'] as double,
//         category: Category(name: json['category'] as String),
//         type: _parseTransactionType(json['type'] as String),
//         createdTime: DateTime.parse(json['createdTime'] as String),
//       );
//     }).toList();
//   }
//
//   TransactionType _parseTransactionType(String type) {
//     switch (type.toLowerCase()) {
//       case 'income':
//         return TransactionType.income;
//       case 'expense':
//         return TransactionType.expense;
//       default:
//         return TransactionType.expense; // fallback or throw error if you want
//     }
//   }
// }
