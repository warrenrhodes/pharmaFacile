import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'XOF',
      decimalDigits: 0,
    ).format(amount);
  }
}
