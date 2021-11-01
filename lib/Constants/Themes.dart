import 'package:flutter/material.dart';

const Color primaryColorLight =Colors.black;
const Color backgroundColorLight = Color(0xFFF8F7F3);

const Color primaryColorDark = Color(0xFFC7CFC7);
const Color backgroundColorDark = Color(0xFF0E1117);

const Color accentColor = Color(0xFF1F6FEB);
const Color goodColor = Color(0xFF2EA043);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColorDark,
  backgroundColor: backgroundColorDark,
  colorScheme: ThemeData.dark().colorScheme.copyWith(secondary: accentColor, primaryVariant: goodColor),
  iconTheme: const IconThemeData(color: primaryColorDark),
  switchTheme: SwitchThemeData(thumbColor: MaterialStateProperty.all(primaryColorDark), trackColor: MaterialStateProperty.all(primaryColorDark.withOpacity(.4))),
  appBarTheme: const AppBarTheme(elevation: 0, titleTextStyle: TextStyle(color: primaryColorDark, fontSize: 20,), iconTheme:   IconThemeData(color: primaryColorDark)),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColorLight,
  backgroundColor: backgroundColorLight,
  colorScheme: ThemeData.light().colorScheme.copyWith(secondary: accentColor, primaryVariant: goodColor),
  iconTheme: const IconThemeData(color: primaryColorLight),
  appBarTheme: const AppBarTheme(elevation: 0, titleTextStyle: TextStyle(color: primaryColorLight, fontSize: 20), iconTheme:   IconThemeData(color: primaryColorLight)),
);
