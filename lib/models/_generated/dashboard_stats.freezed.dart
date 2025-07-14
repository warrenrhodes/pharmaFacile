// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardStats {

 int get totalProducts; int get lowStockItems; int get expiringItems; int get todaySales; int get todayTransactions; int get totalSuppliers;
/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<DashboardStats> get copyWith => _$DashboardStatsCopyWithImpl<DashboardStats>(this as DashboardStats, _$identity);

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStats&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.lowStockItems, lowStockItems) || other.lowStockItems == lowStockItems)&&(identical(other.expiringItems, expiringItems) || other.expiringItems == expiringItems)&&(identical(other.todaySales, todaySales) || other.todaySales == todaySales)&&(identical(other.todayTransactions, todayTransactions) || other.todayTransactions == todayTransactions)&&(identical(other.totalSuppliers, totalSuppliers) || other.totalSuppliers == totalSuppliers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalProducts,lowStockItems,expiringItems,todaySales,todayTransactions,totalSuppliers);

@override
String toString() {
  return 'DashboardStats(totalProducts: $totalProducts, lowStockItems: $lowStockItems, expiringItems: $expiringItems, todaySales: $todaySales, todayTransactions: $todayTransactions, totalSuppliers: $totalSuppliers)';
}


}

/// @nodoc
abstract mixin class $DashboardStatsCopyWith<$Res>  {
  factory $DashboardStatsCopyWith(DashboardStats value, $Res Function(DashboardStats) _then) = _$DashboardStatsCopyWithImpl;
@useResult
$Res call({
 int totalProducts, int lowStockItems, int expiringItems, int todaySales, int todayTransactions, int totalSuppliers
});




}
/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._self, this._then);

  final DashboardStats _self;
  final $Res Function(DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalProducts = null,Object? lowStockItems = null,Object? expiringItems = null,Object? todaySales = null,Object? todayTransactions = null,Object? totalSuppliers = null,}) {
  return _then(_self.copyWith(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,lowStockItems: null == lowStockItems ? _self.lowStockItems : lowStockItems // ignore: cast_nullable_to_non_nullable
as int,expiringItems: null == expiringItems ? _self.expiringItems : expiringItems // ignore: cast_nullable_to_non_nullable
as int,todaySales: null == todaySales ? _self.todaySales : todaySales // ignore: cast_nullable_to_non_nullable
as int,todayTransactions: null == todayTransactions ? _self.todayTransactions : todayTransactions // ignore: cast_nullable_to_non_nullable
as int,totalSuppliers: null == totalSuppliers ? _self.totalSuppliers : totalSuppliers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DashboardStats implements DashboardStats {
  const _DashboardStats({required this.totalProducts, required this.lowStockItems, required this.expiringItems, required this.todaySales, required this.todayTransactions, required this.totalSuppliers});
  factory _DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);

@override final  int totalProducts;
@override final  int lowStockItems;
@override final  int expiringItems;
@override final  int todaySales;
@override final  int todayTransactions;
@override final  int totalSuppliers;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatsCopyWith<_DashboardStats> get copyWith => __$DashboardStatsCopyWithImpl<_DashboardStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStats&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.lowStockItems, lowStockItems) || other.lowStockItems == lowStockItems)&&(identical(other.expiringItems, expiringItems) || other.expiringItems == expiringItems)&&(identical(other.todaySales, todaySales) || other.todaySales == todaySales)&&(identical(other.todayTransactions, todayTransactions) || other.todayTransactions == todayTransactions)&&(identical(other.totalSuppliers, totalSuppliers) || other.totalSuppliers == totalSuppliers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalProducts,lowStockItems,expiringItems,todaySales,todayTransactions,totalSuppliers);

@override
String toString() {
  return 'DashboardStats(totalProducts: $totalProducts, lowStockItems: $lowStockItems, expiringItems: $expiringItems, todaySales: $todaySales, todayTransactions: $todayTransactions, totalSuppliers: $totalSuppliers)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatsCopyWith<$Res> implements $DashboardStatsCopyWith<$Res> {
  factory _$DashboardStatsCopyWith(_DashboardStats value, $Res Function(_DashboardStats) _then) = __$DashboardStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalProducts, int lowStockItems, int expiringItems, int todaySales, int todayTransactions, int totalSuppliers
});




}
/// @nodoc
class __$DashboardStatsCopyWithImpl<$Res>
    implements _$DashboardStatsCopyWith<$Res> {
  __$DashboardStatsCopyWithImpl(this._self, this._then);

  final _DashboardStats _self;
  final $Res Function(_DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalProducts = null,Object? lowStockItems = null,Object? expiringItems = null,Object? todaySales = null,Object? todayTransactions = null,Object? totalSuppliers = null,}) {
  return _then(_DashboardStats(
totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,lowStockItems: null == lowStockItems ? _self.lowStockItems : lowStockItems // ignore: cast_nullable_to_non_nullable
as int,expiringItems: null == expiringItems ? _self.expiringItems : expiringItems // ignore: cast_nullable_to_non_nullable
as int,todaySales: null == todaySales ? _self.todaySales : todaySales // ignore: cast_nullable_to_non_nullable
as int,todayTransactions: null == todayTransactions ? _self.todayTransactions : todayTransactions // ignore: cast_nullable_to_non_nullable
as int,totalSuppliers: null == totalSuppliers ? _self.totalSuppliers : totalSuppliers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
