import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _preferences;
  static const _keyDarkMode = 'darkmode';
  static Future init() async => _preferences = await SharedPreferences.getInstance();
  ThemeMode get themeMode => getDarkMode() == true ? ThemeMode.dark : ThemeMode.light;
  Future setDarkMode(bool value) async {
    await _preferences!.setBool(_keyDarkMode, value);
  }

  bool? getDarkMode() => _preferences!.getBool(_keyDarkMode);
}
