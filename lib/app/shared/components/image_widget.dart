import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? uri;
  final double width;
  final double height;

  const ImageWidget({
    super.key,
    required this.uri,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: width,
        height: height,
        child: uri != null && uri != ""
            ? Image.network(uri!, fit: BoxFit.cover)
            : Image.asset(
                'lib/app/assets/images/istockphoto.jpg',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
