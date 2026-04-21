import 'package:expense_tracker/app/providers/app_providers.dart';
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

    // updatePreviousDiscount(updatedLineItem);

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
}