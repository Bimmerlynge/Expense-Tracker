import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/app/providers/app_providers.dart';
import 'package:expense_tracker/features/transactions/domain/receipt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/features/transactions/data/expense_tracker_api.dart';


class ExpenseTrackerApiClient implements ExpenseTrackerApi {
  final Ref ref;

  ExpenseTrackerApiClient({required this.ref});

  static const String BASE_URL = "http://192.168.0.200:8080";

  @override
  Future<Receipt> sendImage(File imageFile) async {
    final uri = Uri.parse('$BASE_URL/uploadImage');

    final request = http.MultipartRequest("POST", uri);

    request.files.add(
      await http.MultipartFile.fromPath('imageFile', imageFile.path)
    );
    request.fields['userId'] = ref.read(currentUserProvider).id;

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Image upload failed");
    }

    final body = await response.stream.bytesToString();
    return _toDomain(body);
  }

  Receipt _toDomain(String apiResponse) {
    print(apiResponse);
    final decoded = jsonDecode(apiResponse);
    return Receipt.toDomain(decoded['data']);
  }
}