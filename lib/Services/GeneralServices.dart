import 'package:flutter/material.dart';
import 'package:personal_recipes/Screens/AddRecipeScreen.dart';
import 'package:personal_recipes/Screens/RecipesScreen.dart';
import 'package:personal_recipes/Services/SharedPrefs.dart';


import '../locator.dart';

class GeneralServices extends ChangeNotifier {
   //----------SERVICES----------//
  final SharedPrefs _sharedPreferences =
      locator<SharedPrefs>();
  //----------------------------//

  ThemeMode get themeMode => _sharedPreferences.themeMode;
  bool? get darkMode => _sharedPreferences.getDarkMode() ?? false;
  Future<void> setDarkMode(bool value) async {
    await _sharedPreferences.setDarkMode(value);
    notifyListeners();
  }

  int _index = 0;
  int get index => _index;
  setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  List<Widget> screens = const [
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