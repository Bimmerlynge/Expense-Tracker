import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/transactions/domain/discount_item.dart';
import 'package:expense_tracker/features/transactions/domain/line_item.dart';
import 'package:expense_tracker/features/transactions/domain/receipt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final receiptProvider = StateProvider<Receipt>((ref) {
  return Receipt(
      date: DateTime.now(),
      items: [],
      unresolvedDiscounts: []);
});

// final receiptProvider = StateProvider<Receipt>((ref) {
//   return Receipt(
//       date: DateTime.now(),
//       items: [
//         LineItem(id: 0, name: "KYL INDERFILET 600G", price: 49.95, category: Category(name: "Mad")),
//         LineItem(id: 1, name: "SKYR VANILJE", price: 19.95, category: Category(name: "Drikkevarer")),
//         LineItem(id: 2, name: "FK BOOSTER RED BERRY", price: 21.95, category: Category(name: "Mad")),
//         LineItem(id: 3, name: "KYL INDERFILET 600G", price: 45.00, category: Category(name: "Mad")),
//
//       ],
//       unresolvedDiscounts: [DiscountItem(id: 0, name: "RABAT", amount: 19.95), DiscountItem(id: 1, name: "RABAT", amount: 9.95), DiscountItem(id: 2, name: "RABAT", amount: 9.95)]
//   );
// });

