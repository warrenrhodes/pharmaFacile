// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  purchasePrice: (json['purchasePrice'] as num).toDouble(),
  sellingPrice: (json['sellingPrice'] as num).toDouble(),
  stock: (json['stock'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  minStock: (json['minStock'] as num).toInt(),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  description: json['description'] as String?,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'purchasePrice': instance.purchasePrice,
  'sellingPrice': instance.sellingPrice,
  'stock': instance.stock,
  'createdAt': instance.createdAt.toIso8601String(),
  'minStock': instance.minStock,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'description': instance.description,
};
