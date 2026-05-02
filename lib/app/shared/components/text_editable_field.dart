import 'package:flutter/material.dart';

class TextEditableField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onValueChanged;
  final TextAlign? textAlign;
  final double? fontSize;

  const TextEditableField({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
    this.textAlign,
    this.fontSize
  });

  @override
  State<TextEditableField> createState() => _TextEditableFieldState();
}

class _TextEditableFieldState extends State<TextEditableField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void didUpdateWidget(covariant TextEditableField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }

  void _selectAll() {
    _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _onFocusLost();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: _onSubmit,
      onChanged: _onSubmit,
      controller: _controller,
      focusNode: _focusNode,
      onTap: _selectAll,
      style: TextStyle(fontSize: widget.fontSize ?? 14),
      textAlign: widget.textAlign ?? TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
      ),
    );
  }

  Future<void> _onSubmit(String value) async {
    widget.onValueChanged.call(value);
  }

  void _onFocusLost() {
    final value = _controller.text;

    if (value == widget.initialValue.toString()) {
      return;
    }

    widget.onValueChanged.call(value);
  }
}