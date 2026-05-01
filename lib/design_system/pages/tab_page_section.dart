import 'package:flutter/material.dart';

class TabPageSection {
  final Widget header;
  final Widget body;
  final double headerHeightExtension;

  const TabPageSection({
    required this.header,
    required this.body,
    this.headerHeightExtension = 0
  });
}