import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PremiumBlueButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final AlignmentGeometry linearBegin;
  final AlignmentGeometry linearEnd;
  final IconData? icon;
  final AlignmentGeometry? radialCenter;


  const PremiumBlueButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.linearBegin,
    required this.linearEnd,
    this.icon,
    this.radialCenter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
          gradient: LinearGradient(
            begin: linearBegin,
            end: linearEnd,
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
          ),
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
                    style: const TextStyle(
                      color: Colors.white,
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