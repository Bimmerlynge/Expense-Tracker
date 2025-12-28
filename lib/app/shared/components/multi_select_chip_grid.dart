import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectChipGrid<T> extends StatefulWidget {
  final List<MultiSelectItem<T>> items;
  final List<T> selected;
  final ValueChanged<List<T>> onChanged;

  const MultiSelectChipGrid({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<MultiSelectChipGrid<T>> createState() => _MultiSelectChipGridState<T>();
}

class _MultiSelectChipGridState<T> extends State<MultiSelectChipGrid<T>> {
  late List<T> tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2, // number of chips per row
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3, // width / height ratio for each chip
      physics: const NeverScrollableScrollPhysics(),
      children: widget.items.map((item) {
        final isSelected = tempSelected.contains(item.value);
        return ChoiceChip(
          label: Text(item.label),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                tempSelected.add(item.value);
              } else {
                tempSelected.remove(item.value);
              }
            });
            widget.onChanged(tempSelected);
          },
        );
      }).toList(),
    );
  }
}
