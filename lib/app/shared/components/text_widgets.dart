
import 'package:expense_tracker/app/shared/util/app_colors.dart';
import 'package:flutter/cupertino.dart';

Widget text24Normal({String text = "", Color color = AppColors.primaryText}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.normal
    ),
  );
}