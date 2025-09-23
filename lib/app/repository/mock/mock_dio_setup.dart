import 'package:dio/dio.dart';
import 'package:expense_tracker/app/repository/mock/handlers/handle_transactions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'mock_interceptor.dart';
import 'mock_router.dart';

final Dio dio = Dio();

void setupMockDio() {
  if (dotenv.env['USE_MOCK'] == 'true') {
    final router = MockRouter();
    router.addHandler(RegExp('/transactions'), handleTransactions);

    dio.interceptors.add(MockInterceptor(router: router));
  }
}
