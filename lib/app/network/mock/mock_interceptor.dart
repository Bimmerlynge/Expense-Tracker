import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../shared/exceptions/mock_handler_not_found_exception.dart';
import 'mock_router.dart';

class MockInterceptor extends Interceptor {
  final MockRouter router;

  MockInterceptor({required this.router});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final response = await router.handle(options);
      return handler.resolve(response);
    } on MockHandlerNotFoundException catch (e) {
      debugPrint('$e');
      _resolveError(options, handler, e.toString());
    }
  }

  void _resolveError(RequestOptions options, RequestInterceptorHandler handler, String message) {
    handler.resolve(
      Response(
        requestOptions: options,
        statusCode: 501,
        data: {'message': 'No mock handler. Skipped request.'},
      ),
    );
  }
}