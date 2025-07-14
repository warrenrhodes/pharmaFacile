// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  id: json['id'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  productId: json['productId'] as String,
  userId: json['userId'] as String,
  quantity: (json['quantity'] as num).toInt(),
  price: json['price'] as num,
  total: json['total'] as num,
  date: DateTime.parse(json['date'] as String),
  notes: json['notes'] as String?,
  receiptNumber: json['receiptNumber'] as String?,
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'productId': instance.productId,
      'userId': instance.userId,
      'quantity': instance.quantity,
      'price': instance.price,
      'total': instance.total,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
      'receiptNumber': instance.receiptNumber,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.stockIn: 'stockIn',
  TransactionType.sale: 'sale',
};
