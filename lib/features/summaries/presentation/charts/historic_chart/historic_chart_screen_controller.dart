import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:expense_tracker/features/summaries/application/summary_service.dart';
import 'package:expense_tracker/features/summaries/domain/historic_category_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'historic_chart_screen_controller.g.dart';

@riverpod
class HistoricChartScreenController extends _$HistoricChartScreenController {
  @override
  void build() {}

  Future<HistoricCategoryList> getList() async {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month + 1, 1);
    final start = DateTime(end.year, end.month - 6, 1);

    final transactions = await ref
        .read(summaryServiceProvider)
        .getTransactionsInRange(start, end);
    return _toHistoric(transactions);
  }

  HistoricCategoryList _toHistoric(List<Transaction> transactions) {
    final list = HistoricCategoryList();
    for (final t in transactions) {
      list.addToList(t);
    }
    return list;
  }

  Future<void> updateLegendColor(Category category) async {
    await ref.read(summaryServiceProvider).updateHistoricLegendColor(category);
  }
}
