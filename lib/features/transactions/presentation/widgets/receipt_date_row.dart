import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptDateRow extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const ReceiptDateRow({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<ReceiptDateRow> createState() => _ReceiptDateRowState();
}

class _ReceiptDateRowState extends State<ReceiptDateRow> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 60)),
      lastDate: DateTime.now().add(Duration(days: 30)),
      locale: const Locale('da', 'DK')
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d. MMMM yyyy', 'da_DK').format(selectedDate);

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.whiter,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kvitteringsdato',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}