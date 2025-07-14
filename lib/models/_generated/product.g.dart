// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  barcode: json['barcode'] as String,
  categoryId: json['categoryId'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  expiryDate: DateTime.parse(json['expiryDate'] as String),
  supplierId: json['supplierId'] as String,
  reorderThreshold: (json['reorderThreshold'] as num).toInt(),
  batchNumber: json['batchNumber'] as String?,
  manufacturer: json['manufacturer'] as String?,
  createdAtInUtc: DateTime.parse(json['createdAtInUtc'] as String),
  updatedAtInUtc: DateTime.parse(json['updatedAtInUtc'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'barcode': instance.barcode,
  'categoryId': instance.categoryId,
  'price': instance.price,
  'quantity': instance.quantity,
  'expiryDate': instance.expiryDate.toIso8601String(),
  'supplierId': instance.supplierId,
  'reorderThreshold': instance.reorderThreshold,
  'batchNumber': instance.batchNumber,
  'manufacturer': instance.manufacturer,
  'createdAtInUtc': instance.createdAtInUtc.toIso8601String(),
  'updatedAtInUtc': instance.updatedAtInUtc.toIso8601String(),
};
