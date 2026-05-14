import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  double responsiveFont(double size) {
    final scale = width / 390; // iPhone 13 baseline
    return size * scale.clamp(0.85, 1.15);
  }

  double responsiveSpacing(double size) {
    final scale = width / 390;
    return size * scale.clamp(0.85, 1.2);
  }
}

extension Responsive on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  bool get isSmallPhone => screenWidth < 400;
  bool get isMediumPhone => screenWidth >= 400 && screenWidth < 500;
  bool get isLargePhone => screenWidth >= 500;
}