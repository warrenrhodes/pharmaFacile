import 'package:flutter/material.dart';

import '../../../utils/app_constants.dart';

class HomeProvider extends ChangeNotifier {
  String _activeTab = DashboardItem.dashboard;
  bool _isSidebarOpen = false;

  String get activeTab => _activeTab;
  bool get isSidebarOpen => _isSidebarOpen;

  void changeTab(String tab) {
    _activeTab = tab;
    _isSidebarOpen = false;
    notifyListeners();
  }

  void toggleSidebar({bool? value}) {
    _isSidebarOpen = value ?? !_isSidebarOpen;
    notifyListeners();
  }
}
