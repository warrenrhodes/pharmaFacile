import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    return '${NumberFormat.currency(locale: 'fr_FR', symbol: '', decimalDigits: 0).format(amount)} FCFA';
  }

  /// Format date in French locale
  static String formatDate(DateTime date) {
    return DateFormat('EEEE d MMMM y', 'fr_FR').format(date);
  }

  /// Format time in 24-hour format
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'fr_FR').format(date);
  }
}
