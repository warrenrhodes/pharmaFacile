// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    _DashboardStats(
      totalProducts: (json['totalProducts'] as num).toInt(),
      lowStockItems: (json['lowStockItems'] as num).toInt(),
      expiringItems: (json['expiringItems'] as num).toInt(),
      todaySales: (json['todaySales'] as num).toInt(),
      todayTransactions: (json['todayTransactions'] as num).toInt(),
      totalSuppliers: (json['totalSuppliers'] as num).toInt(),
    );

Map<String, dynamic> _$DashboardStatsToJson(_DashboardStats instance) =>
    <String, dynamic>{
      'totalProducts': instance.totalProducts,
      'lowStockItems': instance.lowStockItems,
      'expiringItems': instance.expiringItems,
      'todaySales': instance.todaySales,
      'todayTransactions': instance.todayTransactions,
      'totalSuppliers': instance.totalSuppliers,
    };
