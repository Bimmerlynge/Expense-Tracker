import 'package:expense_tracker/features/summaries/domain/balance_total.dart';
import 'package:expense_tracker/features/summaries/providers/balance_totals_list_async_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'balance_totals_list_provider.g.dart';

@riverpod
List<BalanceTotal> balanceTotalsList(Ref ref) {
  final listAsync = ref.watch(balanceTotalsAsyncProvider);

  return listAsync.maybeWhen(
      data: (list) => list,
      orElse: () => List.empty());
}