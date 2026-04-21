import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:flutter/material.dart';

class NumberEditableField extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onValueChanged;
  final TextAlign? textAlign;
  final double? fontSize;

  const NumberEditableField({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
    this.textAlign,
    this.fontSize});

  @override
  State<NumberEditableField> createState() => _NumberEditableFieldState();
}

class _NumberEditableFieldState extends State<NumberEditableField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void didUpdateWidget(covariant NumberEditableField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue.toStringAsFixed(2);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toStringAsFixed(2));
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _onFocusLost();
      }
    });
  }

  void _selectAll() {
    _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length
    );


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
      controller: _controller,
      focusNode: _focusNode,
      onTap: _selectAll,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(fontSize: widget.fontSize ?? 14),
      textAlign: widget.textAlign ?? TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
      ),
    );
  }

  Future<void> _onSubmit(String value) async {
    if (!isValid(value)) return;

    final newValue = double.parse(value);
    widget.onValueChanged.call(newValue);
  }

  void _onFocusLost() {
    final value = _controller.text;

    if (value == widget.initialValue.toString()) {
      return;
    }

    if (!isValid(value)) return;

    final newValue = double.parse(value);
    widget.onValueChanged.call(newValue);
  }

  bool isValid(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) {
      ToastService.showErrorToast('Ugyldig værd: $value');
      return false;
    }

    return true;
  }
}
