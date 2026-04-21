import 'package:intl/intl.dart';

extension TransactionDateFormatting on DateTime {
  String formatDate() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}

extension StringFormatting on String {
  DateTime toDateTime() {
    final acceptedFormats = [
      DateFormat("dd-MM-yy"),
      DateFormat("yyyy-MM-dd")
    ];

    for (final format in acceptedFormats) {
      try {
        return format.parseStrict(this);
      } catch (_) {}
    }

    throw FormatException("Unable to parse dateString");
  }
}
