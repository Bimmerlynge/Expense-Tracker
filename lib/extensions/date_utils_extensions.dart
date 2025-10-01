
import 'package:intl/intl.dart';

extension TransactionDateFormatting on DateTime {
  String formatDate() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}