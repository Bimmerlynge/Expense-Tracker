import 'dart:io';

import 'package:expense_tracker/features/transactions/application/camera_service.dart';
import 'package:expense_tracker/features/transactions/providers/receipt_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_screen_controller.g.dart';

@riverpod
class CameraScreenController extends _$CameraScreenController {

  @override
  void build() {}

  Future<void> takeImage(File imageFile) async {
    final receipt = await ref.read(cameraServiceProvider).sendImage(imageFile);
    ref.read(receiptProvider.notifier).state = receipt;
  }
}