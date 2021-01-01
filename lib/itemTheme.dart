import 'package:flutter/material.dart';

class ItemTheme {
  static ThemeData themeData = ThemeData(
    fontFamily: "openhuninn",
    backgroundColor: Color.fromRGBO(254, 246, 227, 1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(254, 246, 227, 1),
      shape: RoundedRectangleBorder(),
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 18),
      bodyText2: TextStyle(fontSize: 30),
      subtitle1: TextStyle(fontSize: 25),
      button: TextStyle(fontSize: 20),
    ),
  );
}
