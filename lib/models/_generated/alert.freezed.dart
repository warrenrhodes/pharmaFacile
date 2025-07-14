// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Alert {

 String get id; AlertType get type; String get message; SeverityType get severity; String? get productId; DateTime get createdAtInUtc; bool get read;
/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertCopyWith<Alert> get copyWith => _$AlertCopyWithImpl<Alert>(this as Alert, _$identity);

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alert&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.createdAtInUtc, createdAtInUtc) || other.createdAtInUtc == createdAtInUtc)&&(identical(other.read, read) || other.read == read));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,message,severity,productId,createdAtInUtc,read);

@override
String toString() {
  return 'Alert(id: $id, type: $type, message: $message, severity: $severity, productId: $productId, createdAtInUtc: $createdAtInUtc, read: $read)';
}


}

/// @nodoc
abstract mixin class $AlertCopyWith<$Res>  {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) _then) = _$AlertCopyWithImpl;
@useResult
$Res call({
 String id, AlertType type, String message, SeverityType severity, String? productId, DateTime createdAtInUtc, bool read
});




}
/// @nodoc
class _$AlertCopyWithImpl<$Res>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._self, this._then);

  final Alert _self;
  final $Res Function(Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? message = null,Object? severity = null,Object? productId = freezed,Object? createdAtInUtc = null,Object? read = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as SeverityType,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,createdAtInUtc: null == createdAtInUtc ? _self.createdAtInUtc : createdAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Alert implements Alert {
  const _Alert({required this.id, required this.type, required this.message, required this.severity, this.productId, required this.createdAtInUtc, required this.read});
  factory _Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

@override final  String id;
@override final  AlertType type;
@override final  String message;
@override final  SeverityType severity;
@override final  String? productId;
@override final  DateTime createdAtInUtc;
@override final  bool read;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertCopyWith<_Alert> get copyWith => __$AlertCopyWithImpl<_Alert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alert&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.createdAtInUtc, createdAtInUtc) || other.createdAtInUtc == createdAtInUtc)&&(identical(other.read, read) || other.read == read));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,message,severity,productId,createdAtInUtc,read);

@override
String toString() {
  return 'Alert(id: $id, type: $type, message: $message, severity: $severity, productId: $productId, createdAtInUtc: $createdAtInUtc, read: $read)';
}


}

/// @nodoc
abstract mixin class _$AlertCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$AlertCopyWith(_Alert value, $Res Function(_Alert) _then) = __$AlertCopyWithImpl;
@override @useResult
$Res call({
 String id, AlertType type, String message, SeverityType severity, String? productId, DateTime createdAtInUtc, bool read
});




}
/// @nodoc
class __$AlertCopyWithImpl<$Res>
    implements _$AlertCopyWith<$Res> {
  __$AlertCopyWithImpl(this._self, this._then);

  final _Alert _self;
  final $Res Function(_Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? message = null,Object? severity = null,Object? productId = freezed,Object? createdAtInUtc = null,Object? read = null,}) {
  return _then(_Alert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AlertType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as SeverityType,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String?,createdAtInUtc: null == createdAtInUtc ? _self.createdAtInUtc : createdAtInUtc // ignore: cast_nullable_to_non_nullable
as DateTime,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
