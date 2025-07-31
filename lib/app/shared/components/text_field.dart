import 'package:flutter/material.dart';

class TextField extends StatelessWidget {
  final String text;
  const TextField({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
     
    );
  }
}
