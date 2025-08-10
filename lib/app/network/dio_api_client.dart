// ignore_for_file: unused_field

import 'package:dio/dio.dart';
import 'package:expense_tracker/app/network/api_client.dart';
import 'package:expense_tracker/app/network/mock/mock_dio_setup.dart';

class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient(this._dio);

  @override
  Future<void> delete(String path) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<T> get<T>(String path) async {
    var response = await dio.get(path);
    return response.data;
  }

  @override
  Future<T> post<T>(String path, {data}) {
    // TODO: implement post
    throw UnimplementedError();
  }
}
