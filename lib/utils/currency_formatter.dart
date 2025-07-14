import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatCurrency(double amount, Locale locale) {
    const String frenchLocale = 'fr';
    const String englishLocale = 'en';

    return NumberFormat.currency(
      name: 'XAF',
      symbol: '${NumberFormat.simpleCurrency(name: 'XAF').currencySymbol} ',
      locale: locale.languageCode.toLowerCase() == frenchLocale
          ? frenchLocale
          : englishLocale,
    ).format(amount);
  }
}
