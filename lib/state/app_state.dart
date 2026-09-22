import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const String _darkModeKey = 'is_dark_mode';
  static const String _userNameKey = 'user_name';
  static const String _profileImagePathKey =
      'profile_image_path';

  bool _isDarkMode = false;

  String _userName = 'User';

  String? _profileImagePath;

  late SharedPreferences _preferences;

  bool get isDarkMode => _isDarkMode;

  String get userName => _userName;

  String? get profileImagePath => _profileImagePath;

  Future<void> loadSavedData() async {
    _preferences = await SharedPreferences.getInstance();

    _isDarkMode =
        _preferences.getBool(_darkModeKey) ?? false;

    _userName =
        _preferences.getString(_userNameKey) ?? 'User';

    _profileImagePath =
        _preferences.getString(_profileImagePathKey);

    notifyListeners();
  }

  void toggleTheme(bool value) {
    _isDarkMode = value;

    _preferences.setBool(
      _darkModeKey,
      value,
    );

    notifyListeners();
  }

  void updateUserName(String value) {
    final String trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return;
    }

    _userName = trimmedValue;

    _preferences.setString(
      _userNameKey,
      _userName,
    );

    notifyListeners();
  }

  void updateProfileImage(String? imagePath) {
    _profileImagePath = imagePath;

    if (imagePath == null) {
      _preferences.remove(
        _profileImagePathKey,
      );
    } else {
      _preferences.setString(
        _profileImagePathKey,
        imagePath,
      );
    }

    notifyListeners();
  }

  void removeProfileImage() {
    _profileImagePath = null;

    _preferences.remove(
      _profileImagePathKey,
    );

    notifyListeners();
  }
}