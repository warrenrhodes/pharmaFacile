import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String? pin; // For demonstration only; in production, use secure auth
  final String username;

  AppUser({required this.uid, this.pin, required this.username});

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        uid: json['uid'] as String,
        pin: json['pin'] as String?,
        username: json['username'] as String,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'pin': pin,
        'username': username,
      };
}
