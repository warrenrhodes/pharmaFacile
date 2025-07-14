import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/dashboard_stats.freezed.dart';
part '_generated/dashboard_stats.g.dart';

@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int totalProducts,
    required int lowStockItems,
    required int expiringItems,
    required int todaySales,
    required int todayTransactions,
    required int totalSuppliers,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
}
