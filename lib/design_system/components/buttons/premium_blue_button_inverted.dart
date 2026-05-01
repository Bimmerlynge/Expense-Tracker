import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PremiumBlueButtonInverted extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final AlignmentGeometry linearBegin;
  final AlignmentGeometry linearEnd;
  final IconData? icon;
  final AlignmentGeometry? radialCenter;
  final double height;


  const PremiumBlueButtonInverted({
    super.key,
    required this.text,
    required this.onTap,
    this.linearBegin = Alignment.topLeft,
    this.linearEnd = Alignment.bottomRight,
    this.icon,
    this.radialCenter,
    this.height = 54
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
          color: AppColors.whiter
        ),
        child: Stack(
          children: [
            if (radialCenter != null) ... {
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: RadialGradient(
                      center: radialCenter!,
                      radius: 1.1,
                      colors: [
                        Colors.white.withOpacity(.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              )
            },
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...{
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 10),
                  },
                  Text(
                    text,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}