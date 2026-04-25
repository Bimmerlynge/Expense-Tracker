import 'dart:io';

import 'package:camera/camera.dart';
import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/app/shared/widgets/arrow_back_button.dart';
import 'package:expense_tracker/app/shared/widgets/gray_box.dart';
import 'package:expense_tracker/app/shared/widgets/header_title.dart';
import 'package:expense_tracker/app/shared/widgets/premium_blue.dart';
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
  bool _isFlashOn = true;

  @override
  void initState() {
    super.initState();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium
    );

    initFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    await cameraController.initialize();

    await cameraController.setFlashMode(FlashMode.always);
    await cameraController.setFocusMode(FocusMode.auto);

    setState(() {
      _isFlashOn = true;
    });
  }

  Future<void> _toggleFlash() async {
    if (_isFlashOn) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController.setFlashMode(FlashMode.always);
    }

    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _body();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        _background(),
        _content()
      ],
    );
  }

  Widget _content() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _header(),
            SizedBox(height: 20,),
            _instructionText(),
            SizedBox(height: 20,),
            _cameraPreview(),
            SizedBox(height: 20,),
            _captureButton(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ArrowBackButton(onClick: () {}),
            ),
            const HeaderTitle(title: "Scan kvittering")
          ],
        ),
      ),
    );
  }

  Widget _instructionText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.darkBlueAccent,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary,
                width: 2
              )
            ),
            child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white70)
        ),
        const SizedBox(width: 8),
        const Text(
          'Placer kvitteringen indenfor rammen',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _cameraPreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.whiter,
      ),
      padding: EdgeInsets.all(4),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
              children: [
                CameraPreview(cameraController),
                Positioned(top: 10, left: 10, child: _corner()),
                Positioned(top: 10, right: 10, child: _corner(isRight: true)),
                Positioned(bottom: 10, left: 10, child: _corner(isBottom: true)),
                Positioned(bottom: 10, right: 10, child: _corner(isBottom: true, isRight: true)),
                Positioned(bottom: 10, left: 0, right: 0, child: _flashIcon())
              ]
          )
      ),
    );
  }

  Widget _corner({bool isRight = false, bool isBottom = false}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: (!isRight && !isBottom)
              ? const Radius.circular(12)
              : Radius.zero,
          topRight: (isRight && !isBottom)
              ? const Radius.circular(12)
              : Radius.zero,
          bottomLeft: (!isRight && isBottom)
              ? const Radius.circular(12)
              : Radius.zero,
          bottomRight: (isRight && isBottom)
              ? const Radius.circular(12)
              : Radius.zero,
        ),
        border: Border(
          top: isBottom ? BorderSide.none : const BorderSide(color: Colors.white, width: 3),
          left: isRight ? BorderSide.none : const BorderSide(color: Colors.white, width: 3),
          right: isRight ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
          bottom: isBottom ? const BorderSide(color: Colors.white, width: 3) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _flashIcon() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: _toggleFlash,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isFlashOn
                ? Icons.flash_on
                : Icons.flash_off,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _captureButton() {
    return PremiumBlueButton(
        text: "Tag billed",
        icon: Icons.camera_alt_rounded,
        onTap: takeImage,
        linearBegin: Alignment.topLeft,
        linearEnd: Alignment.bottomRight
    );
  }

  Widget _background() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(34),
          ),
        )
    );
  }

  Future<void> takeImage() async {
    if (!cameraController.value.isInitialized) return;

    final xfile = await cameraController.takePicture();

    try {
      await ref
          .read(cameraScreenControllerProvider.notifier)
          .takeImage(File(xfile.path));

      Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReceiptReviewScreen())
      );
    } catch (e) {
      ToastService.showErrorToast("Kunne ikke aflæse billedet. Forsøg at lave et vandret og fokuseret billed");
    }
  }
}
