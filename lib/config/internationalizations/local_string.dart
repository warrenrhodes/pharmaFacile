import 'dart:ui';

import 'package:logging/logging.dart';

/// LocalizedString defines a string in multiple languages.
/// A LocalizedString may be a local string (AppInternationalization)
/// or may have been queried from the database.
class LocalizedString {
  final Map<String, String> _raw;
  static final _log = Logger('LocalizedString');

  /// Placeholder for missing translations.
  static const String placeholder = '__Placeholder__';

  /// Language to fallback to.
  static const String defaultLanguage = 'en';

  /// Constructs a LocalizedString from a jsonMap (Map<dynamic, dynamic>).
  LocalizedString(Map<dynamic, dynamic> jsonMap)
    : _raw = Map<String, String>.from(jsonMap);

  /// Returns the string in the specified locale.
  /// Use Localizations.localeOf(context) to retrieve the current
  /// app locale.
  String get(Locale locale) {
    final language = locale.languageCode;
    if (_raw.containsKey(language)) {
      return _raw[language]!;
    }
    _log.severe(
      'Missing language "$language" in localized string "$_raw".',
      null,
      StackTrace.current,
    );

    return _raw[defaultLanguage] ?? placeholder;
  }
}
