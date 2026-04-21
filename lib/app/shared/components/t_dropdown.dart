import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T value;
  final ValueChanged<T> onChanged;
  final Color? dropdownColor;
  final Icon? icon;
  final String Function(T) label;
  final Alignment textAlign;
  final double iconSize;
  final double fontSize;

  const TDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.dropdownColor,
    this.icon,
    required this.label,
    this.textAlign = Alignment.center,
    this.iconSize = 24,
    this.fontSize = 14
  });

  @override
  State<TDropdown<T>> createState() => _TDropdownState<T>();
}

class _TDropdownState<T> extends State<TDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isDense: true,
        isExpanded: true,
        icon: widget.icon ?? const SizedBox.shrink(),
        iconSize: widget.iconSize,
        dropdownColor: widget.dropdownColor ?? AppColors.white,
        value: widget.value,
        items: widget.items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: widget.textAlign,
                    child: Text(
                        widget.label(item),
                        style: TextStyle(fontSize: widget.fontSize, overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            widget.onChanged.call(newValue);
          }
        },
      ),
    );
  }
}
