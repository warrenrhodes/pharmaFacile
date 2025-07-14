import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/audit_log.freezed.dart';
part '_generated/audit_log.g.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    required String action,
    required String entityType,
    required String entityId,
    required String userId,
    required String timestamp,
    required Map<String, dynamic> details,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}
