import 'package:flutter/foundation.dart';
import 'package:pharmacie_stock/utils/fake.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  final List<User> _users = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  AuthProvider() {
    login('');
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // _users = await DatabaseService.instance.getAllUsers();
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email) async {
    try {
      if (_users.isEmpty) {
        await loadUsers();
      }

      final user = fakeUsers.first;
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  bool hasPermission(PermissionType permission) {
    final currentUser = _currentUser;
    if (currentUser == null) return false;
    return currentUser.permissions.contains(permission);
  }
}
