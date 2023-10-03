import 'package:flutter/material.dart';
class ThemeProvider extends ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void setDarkMode(bool value) {
    _isDarkModeEnabled = value;
    notifyListeners();
  }

}

