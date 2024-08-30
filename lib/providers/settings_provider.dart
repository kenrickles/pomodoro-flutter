import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPreferences prefs;

  SettingsProvider(this.prefs) {
    _loadSettings();
  }

  bool _soundEnabled = true;
  bool get soundEnabled => _soundEnabled;

  void _loadSettings() {
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    prefs.setBool('soundEnabled', _soundEnabled);
    notifyListeners();
  }
}