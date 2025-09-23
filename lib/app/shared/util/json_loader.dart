import 'dart:convert';

import 'package:flutter/services.dart';

Future<dynamic> loadJson(String fileName) async {
  final jsonString = await rootBundle.loadString(
    'lib/app/repository/mock/responses/$fileName.json',
  );
  return json.decode(jsonString);
}
