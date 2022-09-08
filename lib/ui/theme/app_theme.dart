import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    backgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColorDark),
      headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: primaryColorDark),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: primaryColor),
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: const ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      highlightColor: null,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
