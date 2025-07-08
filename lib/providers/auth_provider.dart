import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  AuthState({required this.isAuthenticated});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  void signIn() => state = AuthState(isAuthenticated: true);
  void signOut() => state = AuthState(isAuthenticated: false);
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
