// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => _AuditLog(
  id: json['id'] as String,
  action: json['action'] as String,
  entityType: json['entityType'] as String,
  entityId: json['entityId'] as String,
  userId: json['userId'] as String,
  timestamp: json['timestamp'] as String,
  details: json['details'] as Map<String, dynamic>,
);

Map<String, dynamic> _$AuditLogToJson(_AuditLog instance) => <String, dynamic>{
  'id': instance.id,
  'action': instance.action,
  'entityType': instance.entityType,
  'entityId': instance.entityId,
  'userId': instance.userId,
  'timestamp': instance.timestamp,
  'details': instance.details,
};
