import 'dart:async';

import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/application/summary_service.dart';
import 'package:expense_tracker/features/summaries/domain/category_spending_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_chart_screen_controller.g.dart';

@riverpod
class CategoryChartScreenController extends _$CategoryChartScreenController {
  late final StreamSubscription<CategorySpendingList> _subscription;

  @override
  FutureOr<CategorySpendingList> build() {
    state = AsyncLoading();

    final service = ref.read(summaryServiceProvider);
    
    final stream = service.getTransactionsCurrentMonth()
        .map(_toCategorySpending);

    _subscription = stream.listen(
        (categorySpendingList) => state = AsyncData(categorySpendingList),
      onError: (error, stack) => state = AsyncError(error, stack),
    );

    ref.onDispose(() => _subscription.cancel());

    return stream.first;
  }

  CategorySpendingList _toCategorySpending(List<Transaction> transactions) {
    final list = CategorySpendingList();
    for (var t in transactions) {
      list.addToList(t);
    }

    return list;
  }

  // void applyShowOnlyMine(bool onlyMine, String currentUserId) {
  //   final currentState = state;
  //   if (currentState is! AsyncData<List<CategorySpending>>) return;
  //
  //   // Re-filter existing transactions
  //   final filtered = _toCategorySpending(
  //     currentState.value
  //         .map((cs) => Transaction(
  //       user: User(id: currentUserId),
  //       category: Category(name: cs.name),
  //       amount: cs.total,
  //       type: TransactionType.expense,
  //       transactionTime: DateTime.now(),
  //     ))
  //         .toList(),
  //     onlyCurrentUser: onlyMine,
  //     currentUserId: currentUserId,
  //   );
  //
  //   state = AsyncData(filtered);
  // }


}