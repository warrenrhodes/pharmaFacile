// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Supplier _$SupplierFromJson(Map<String, dynamic> json) => _Supplier(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  isActive: json['isActive'] as bool,
  notes: json['notes'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String?,
  createdAtInUtc: DateTime.parse(json['createdAtInUtc'] as String),
);

Map<String, dynamic> _$SupplierToJson(_Supplier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'isActive': instance.isActive,
  'notes': instance.notes,
  'email': instance.email,
  'address': instance.address,
  'createdAtInUtc': instance.createdAtInUtc.toIso8601String(),
};
