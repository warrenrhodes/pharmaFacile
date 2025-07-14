// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Alert _$AlertFromJson(Map<String, dynamic> json) => _Alert(
  id: json['id'] as String,
  type: $enumDecode(_$AlertTypeEnumMap, json['type']),
  message: json['message'] as String,
  severity: $enumDecode(_$SeverityTypeEnumMap, json['severity']),
  productId: json['productId'] as String?,
  createdAtInUtc: DateTime.parse(json['createdAtInUtc'] as String),
  read: json['read'] as bool,
);

Map<String, dynamic> _$AlertToJson(_Alert instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$AlertTypeEnumMap[instance.type]!,
  'message': instance.message,
  'severity': _$SeverityTypeEnumMap[instance.severity]!,
  'productId': instance.productId,
  'createdAtInUtc': instance.createdAtInUtc.toIso8601String(),
  'read': instance.read,
};

const _$AlertTypeEnumMap = {
  AlertType.LOWSTOCK: 'LOWSTOCK',
  AlertType.EXPIRY: 'EXPIRY',
  AlertType.BACKUP: 'BACKUP',
};

const _$SeverityTypeEnumMap = {
  SeverityType.LOW: 'LOW',
  SeverityType.MEDIUM: 'MEDIUM',
  SeverityType.HIGTH: 'HIGTH',
};
