import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  ThemeMode get themeMode =>
      getDarkMode() == true ? ThemeMode.dark : ThemeMode.light;

  static const _keyDarkMode = 'darkmode';
  bool? getDarkMode() => _preferences!.getBool(_keyDarkMode);
  Future setDarkMode(bool value) async {
    await _preferences!.setBool(_keyDarkMode, value);
  }

  static const _keyShowOnboarding = 'onboarding';
  bool? getOnboarding() => _preferences!.getBool(_keyShowOnboarding);
  Future setShowOnboarding(bool value) async {
    await _preferences!.setBool(_keyShowOnboarding, value);
  }
}
