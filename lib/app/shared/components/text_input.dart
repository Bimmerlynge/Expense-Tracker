import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String label;

  const TextInput({super.key, this.label = ""});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
    );
  }
}
