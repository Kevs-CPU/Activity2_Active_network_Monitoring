import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  String _userName = 'Guest User';

  bool get isDarkMode => _isDarkMode;
  String get userName => _userName;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void updateUserName(String value) {
    if (value.trim().isEmpty) return;
    _userName = value.trim();
    notifyListeners();
  }
}
