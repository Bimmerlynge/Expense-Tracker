import 'package:flutter/material.dart';

enum ToastEnum { success, failure, info }

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ToastService {
  static void _buildSnackBar({
    required String message,
    required Icon icon,
    Color textColor = Colors.white,
    Color backgroundColor = Colors.black87,
  }) {
    final scaffoldMessenger = rootScaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null) return;

    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: TextStyle(color: textColor)),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccessToast(String message) {
    _buildSnackBar(
      message: message,
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
    );
  }

  static void showInfoToast(String message) {
    _buildSnackBar(
      message: message,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  static void showErrorToast(String message) {
    _buildSnackBar(message: message, icon: const Icon(Icons.cancel_outlined));
  }
}
