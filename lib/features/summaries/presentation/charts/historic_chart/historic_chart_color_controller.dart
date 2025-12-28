import 'dart:async';

import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/features/categories/application/category_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'historic_chart_color_controller.g.dart';

@riverpod
class HistoricChartColorController extends _$HistoricChartColorController {
  late final StreamSubscription<List<Category>> _subscription;

  @override
  FutureOr<List<Category>> build() async {
    final service = ref.read(categoryServiceProvider);
    final stream = service.getHouseholdCategoriesStream();

    _subscription = stream.listen((categories) {
      state = AsyncValue.data(categories);
    });

    ref.onDispose(() => _subscription.cancel());

    return await stream.first;
  }

  Future<void> updateColor() async {}
}
