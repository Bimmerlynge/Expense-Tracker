import 'dart:io';

import 'package:camera/camera.dart';
import 'package:expense_tracker/features/transactions/presentation/camera_screen/camera_screen_controller.dart';
import 'package:expense_tracker/features/transactions/presentation/receipt_review_screen/receipt_review_screen.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late CameraController cameraController;
  late Future<void> initFuture;

  @override
  void initState() {
    super.initState();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium
    );

    initFuture = cameraController.initialize();
    cameraController.setFlashMode(FlashMode.always);
    cameraController.setFocusMode(FocusMode.auto);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: () => takeImage()),
      body: FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(cameraController);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> takeImage() async {
    if (!cameraController.value.isInitialized) return;

    final xfile = await cameraController.takePicture();

    await ref
        .read(cameraScreenControllerProvider.notifier)
        .takeImage(File(xfile.path));


    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReceiptReviewScreen())
    );
  }
}
