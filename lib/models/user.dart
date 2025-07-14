import 'package:freezed_annotation/freezed_annotation.dart';

part '_generated/user.freezed.dart';
part '_generated/user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required UserRole role,
    required List<PermissionType> permissions,
    required String passwordHash,
    required DateTime createdAtInUtc,
    String? lastLogin,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

enum PermissionType { inventory, sales, reports, updateSettings }

enum UserRole { admin, pharmacist, assistant }
