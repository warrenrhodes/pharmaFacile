import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/alert.freezed.dart';
part '_generated/alert.g.dart';

@freezed
abstract class Alert with _$Alert {
  const factory Alert({
    required String id,
    required AlertType type,
    required String message,
    required SeverityType severity,
    String? productId,
    required DateTime createdAtInUtc,
    required bool read,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

enum AlertType { LOWSTOCK, EXPIRY, BACKUP }

enum SeverityType { LOW, MEDIUM, HIGTH }
