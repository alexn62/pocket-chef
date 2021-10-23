import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_recipes/Screens/AddRecipeScreen.dart';
import 'package:personal_recipes/Screens/RecipeScreen.dart';
import 'package:personal_recipes/Screens/RecipesScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GeneralServices extends ChangeNotifier {
  static SharedPreferences? _preferences;
  static const _keyDarkMode = 'darkmode';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  ThemeMode get themeMode =>
      getDarkMode == true ? ThemeMode.dark : ThemeMode.light;

  Future setDarkMode(bool value) async {
    await _preferences!.setBool(_keyDarkMode, value);
    notifyListeners();
  }

  bool get getDarkMode => _preferences!.getBool(_keyDarkMode) ?? false;

  int _index = 0;
  int get index => _index;
  setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  List<Widget> screens = [
    RecipesScreen(),
    AddRecipeScreen(),
  ];

  String fraction(int? frac) {
    switch (frac) {
      case 0:
        return '';
      case 25:
        return '¼';
      case 50:
        return '½';
      case 75:
        return '¾';
      default:
        return '';
    }
  }

  String roundToNearestQuarter(double number) {
    double am = ((number) * 4).round() / 4;

    int frac = int.parse(am.toStringAsFixed(2).split('.')[1]);
    return am.floor().toStringAsFixed(0) + fraction(frac);
  }
}
