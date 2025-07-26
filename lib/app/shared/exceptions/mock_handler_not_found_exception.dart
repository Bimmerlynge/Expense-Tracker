class MockHandlerNotFoundException implements Exception {
  final String path;

  MockHandlerNotFoundException(this.path);

  @override
  String toString() => 'No mock handler found for: $path';
}