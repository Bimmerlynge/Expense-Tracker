abstract class ApiClient {
  Future<T> get<T>(String path);
  Future<T> post<T>(String path, {dynamic data});
  Future<void> delete(String path);
}