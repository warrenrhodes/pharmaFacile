// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  permissions: (json['permissions'] as List<dynamic>)
      .map((e) => $enumDecode(_$PermissionTypeEnumMap, e))
      .toList(),
  passwordHash: json['passwordHash'] as String,
  createdAtInUtc: DateTime.parse(json['createdAtInUtc'] as String),
  lastLogin: json['lastLogin'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': _$UserRoleEnumMap[instance.role]!,
  'permissions': instance.permissions
      .map((e) => _$PermissionTypeEnumMap[e]!)
      .toList(),
  'passwordHash': instance.passwordHash,
  'createdAtInUtc': instance.createdAtInUtc.toIso8601String(),
  'lastLogin': instance.lastLogin,
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.pharmacist: 'pharmacist',
  UserRole.assistant: 'assistant',
};

const _$PermissionTypeEnumMap = {
  PermissionType.inventory: 'inventory',
  PermissionType.sales: 'sales',
  PermissionType.reports: 'reports',
  PermissionType.updateSettings: 'updateSettings',
};
