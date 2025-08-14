import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';

Container inputContainer(Widget child) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
      border: BoxBorder.fromBorderSide(
        BorderSide(color: AppColors.primarySecondText),

      ),
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(45),
    ),
    child: child,
  );
}

Widget labelInputContainer({
  required String label,
  required TextEditingController controller,
  bool obscureText = false
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
            label,
            style: TTextTheme.mainTheme.labelMedium
        ),
      ),
      inputContainer(
          TextFormField(
            style: TextStyle(
              color: AppColors.onPrimary,
            ),
            obscureText: obscureText,
            controller: controller,
          )
      ),
    ],
  );
}
