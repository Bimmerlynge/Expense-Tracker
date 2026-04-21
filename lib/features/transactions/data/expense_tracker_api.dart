import 'dart:io';

import 'package:expense_tracker/features/transactions/domain/receipt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseTrackerApiProvider = Provider<ExpenseTrackerApi>((ref) {
  throw UnimplementedError("Api must be overridden");
});

abstract class ExpenseTrackerApi {
  Future<Receipt> sendImage(File image);
}