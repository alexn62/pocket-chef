import 'package:flutter/material.dart';

const Color primaryColorLight = Color(0xFF5E5D54);
const Color backgroundColorLight = Color(0xFFE3E3DA);

const Color primaryColorDark = Color(0xFFC7CFC7);
const Color backgroundColorDark = Color(0xFF0E1117);

const Color accentColorDark = Color(0xFF1F6FEB);
const Color accentColorLight = Color(0xFF967E6B);
const Color goodColor = Color(0xFF2EA043);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    backgroundColor: backgroundColorDark,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: primaryColorDark,
        secondary: accentColorDark,
        primaryVariant: goodColor),
    iconTheme: const IconThemeData(color: primaryColorDark),
    switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(primaryColorDark),
        trackColor:
            MaterialStateProperty.all(primaryColorDark.withOpacity(.4))),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: primaryColorDark,
          fontSize: 17,
        ),
        iconTheme: IconThemeData(color: primaryColorDark)),
    cardTheme: const CardTheme(
        color: backgroundColorDark, shadowColor: primaryColorDark),
    textTheme: const TextTheme(
      bodyText2: TextStyle(color: primaryColorDark),
      subtitle1: TextStyle(color: primaryColorDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryColorDark.withOpacity(0.1),
      contentPadding: const EdgeInsets.all(10),
      isDense: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(),
      ),
    ),
    dividerColor: Colors.transparent);

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    backgroundColor: backgroundColorLight,
    colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: primaryColorLight,
        secondary: accentColorLight,
        primaryVariant: goodColor),
    iconTheme: const IconThemeData(color: primaryColorLight),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: primaryColorLight,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryColorLight)),
    cardTheme: const CardTheme(
      color: backgroundColorLight,
      shadowColor: primaryColorLight,
    ),
    textTheme: const TextTheme(
        bodyText2: TextStyle(color: primaryColorLight),
        subtitle1: TextStyle(color: primaryColorLight)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryColorLight.withOpacity(0.1),
      contentPadding: const EdgeInsets.all(10),
      isDense: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
    ),
    dividerColor: Colors.transparent);
