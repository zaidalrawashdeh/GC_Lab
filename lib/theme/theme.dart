import 'package:flutter/material.dart';

class CustomTheme {
  static final ThemeData myTheme = ThemeData(
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
          backgroundColor: Color(0xff1f63b6),
          iconTheme: IconThemeData(color: Colors.white)),
      useMaterial3: true,
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color(0xff1f63b6),
            ),
            textStyle: MaterialStatePropertyAll(
              TextStyle(color: Colors.white),
            ),
            foregroundColor: MaterialStatePropertyAll(Colors.white)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
}
