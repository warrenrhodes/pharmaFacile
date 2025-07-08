// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sale _$SaleFromJson(Map<String, dynamic> json) => _Sale(
  id: json['id'] as String,
  salesItems: (json['salesItems'] as List<dynamic>)
      .map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPriceInUTC: (json['totalPriceInUTC'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedBy: json['updatedBy'] as String,
  cashier: json['cashier'] as String,
);

Map<String, dynamic> _$SaleToJson(_Sale instance) => <String, dynamic>{
  'id': instance.id,
  'salesItems': instance.salesItems,
  'totalPriceInUTC': instance.totalPriceInUTC,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'cashier': instance.cashier,
};
