import 'dart:math';

import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/extensions/date_utils_extensions.dart';
import 'package:flutter/material.dart';

class DateInputRow extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  const DateInputRow({super.key, required this.initialDate, required this.onChanged});

  @override
  State<DateInputRow> createState() => _DateInputRowState();
}

class _DateInputRowState extends State<DateInputRow> {
  DateTime _selected = DateTime.now();

  @override
  void didUpdateWidget(covariant DateInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialDate != widget.initialDate) {
      _selected = widget.initialDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selected,
            firstDate: DateTime.now().subtract(Duration(days: 60)),
            lastDate: DateTime.now().add(Duration(days: 30)),
            locale: const Locale('da', 'DK')
        );

        if (picked != null) {
          setState(() {
            _selected = picked;
          });

          widget.onChanged.call(picked);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selected.formatDate(), style: TextStyle(fontSize: 16),),
            Icon(Icons.arrow_drop_down, color: AppColors.primarySecondText,)
          ],
        ),
      ),
    );
  }
}
