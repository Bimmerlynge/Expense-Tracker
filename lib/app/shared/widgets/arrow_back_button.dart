import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ArrowBackButton extends StatelessWidget {
  final VoidCallback onClick;

  const ArrowBackButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.darkBlueAccent, // dark blue
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_outlined,
          color: AppColors.white,
        ),
      ),
    );
  }
}
