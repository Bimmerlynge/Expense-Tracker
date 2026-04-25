import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/transactions/application/transaction_service.dart';
import 'package:expense_tracker/features/transactions/domain/discount_item.dart';
import 'package:expense_tracker/features/transactions/domain/line_item.dart';
import 'package:expense_tracker/features/transactions/domain/receipt.dart';
import 'package:expense_tracker/features/transactions/providers/receipt_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receipt_review_screen_controller.g.dart';

@riverpod
class ReceiptReviewScreenController extends _$ReceiptReviewScreenController {

  @override
  Receipt build(){
    return ref.read(receiptProvider);
  }

  Future<void> send() async {
    try {
      final user = ref.read(currentUserProvider);
      final preparedReceipt = state.copyWith(user: user);
      await ref.read(transactionServiceProvider).processReceipt(preparedReceipt);
    } catch (e) {
      rethrow;
    }
  }

  void updateUnresolvedDiscount(DiscountItem updatedItem) {
    final updatedList = state.unresolvedDiscounts.map((d) {
      if (d.id == updatedItem.id) {
        return updatedItem;
      }

      return d;
    }).toList();

    state = state.copyWith(unresolvedDiscounts: updatedList);
  }

  void updatePreviousDiscount(LineItem lineItem) {
    DiscountItem before = state.unresolvedDiscounts.firstWhere((d) => d.appliedTo == lineItem, orElse: () => DiscountItem.nullObject());
    before.appliedTo = null;
    updateUnresolvedDiscount(before);
  }

  void update(DiscountItem discount, LineItem updatedLineItem) {

    updatePreviousDiscount(updatedLineItem);


    final previousItemWithDiscount = discount.appliedTo;
    if (previousItemWithDiscount != null) {
      updatePreviousDiscount(previousItemWithDiscount);
    }

    discount.appliedTo = updatedLineItem;
    updateUnresolvedDiscount(discount);
  }

  bool isItemApplied(LineItem item) {
    bool existingItem = state.unresolvedDiscounts.any((d) => d.appliedTo?.id == item.id);
    return existingItem;
  }

  DiscountItem getLineItemDiscountState(LineItem item) {
    if (isItemApplied(item)) {
      return state.unresolvedDiscounts.firstWhere((d) => d != DiscountItem.nullObject() && d.appliedTo?.id == item.id);
    }
    return DiscountItem.nullObject();
  }
  
  void removeLineItem(int id) {
    final currentList = state.items;
    final currentDiscounts = state.unresolvedDiscounts;

    DiscountItem? discountApplied;

    for (final e in currentDiscounts) {
      if (e.appliedTo?.id == id) {
        discountApplied = e;
        break;
      }
    }

    if (discountApplied != null) {
      discountApplied.appliedTo = null;
    }

    currentList.removeWhere((item) => item.id == id);
    state = state.copyWith(items: currentList, unresolvedDiscounts: currentDiscounts);
  }

  void addLineItem(String name) {
    final currentList = state.items;
    final item = LineItem(id: state.nextId, name: name, price: 0.0, category: Category(name: "Mad"));
    currentList.insert(0, item);

    state = state.copyWith(items: currentList);
  }
}