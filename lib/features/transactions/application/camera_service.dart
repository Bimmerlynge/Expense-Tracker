import 'dart:io';

import 'package:expense_tracker/features/transactions/data/expense_tracker_api.dart';
import 'package:expense_tracker/features/transactions/data/expense_tracker_api_client.dart';
import 'package:expense_tracker/features/transactions/domain/receipt.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService(api: ref.watch(expenseTrackerApiProvider));
});

class CameraService {
  final ExpenseTrackerApi api;

  CameraService({required this.api});

  Future<Receipt> sendImage(File imageFile) async {
    final cleanedFile = await _normalizeImage(imageFile);
    return await api.sendImage(cleanedFile);
  }

  Future<File> _normalizeImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        '${imageFile.path}_cleaned.jpg',
        quality: 95,
        keepExif: false
    );

    return File(result!.path);
  }
}