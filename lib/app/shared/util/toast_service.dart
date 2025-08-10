import 'package:flutter/material.dart';

enum ToastEnum { success, failure, info }

class ToastService {
  static void _buildSnackBar({
    required BuildContext context,
    required String message,
    required Icon icon,
    Color textColor = Colors.white,
    Color backgroundColor = Colors.black87,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

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

  static void showSuccessToast(BuildContext context, String message) {
    _buildSnackBar(
      context: context,
      message: message,
      icon: Icon(Icons.check_circle_outline, color: Colors.green),
    );
  }

  static void showInfoToast(BuildContext context, String message) {
    _buildSnackBar(
      context: context,
      message: message,
      icon: Icon(Icons.info_outline, color: Colors.white),
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    _buildSnackBar(
      context: context,
      message: message,
      icon: Icon(Icons.cancel_outlined),
    );
  }
}
