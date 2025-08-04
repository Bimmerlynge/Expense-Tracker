import 'package:dio/dio.dart';

import '../../../shared/util/json_loader.dart';

Future<Response> handleDawa(RequestOptions options) async {
  return Response(
    requestOptions: options,
    statusCode: 200,
    data: await loadJson('responseDawa'),
  );
}
