import 'package:dio/dio.dart';

import '../../shared/exceptions/mock_handler_not_found_exception.dart';

typedef MockHandler = Future<Response> Function(RequestOptions options);

class MockRouter {
  final Map<Pattern, MockHandler> _routes = {};

  void addHandler(Pattern pattern, MockHandler handler) {
    _routes[pattern] = handler;
  }

  Future<Response> handle(RequestOptions options) async {
    for (var entry in _routes.entries) {
      if (entry.key.allMatches(options.path).isNotEmpty) {
        return entry.value(options);
      }
    }

    return Future.error(MockHandlerNotFoundException(options.path));
  }
}