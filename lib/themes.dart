import 'package:flutter/material.dart';

final ThemeData lightBaseTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: Colors.indigo,
  backgroundColor: Colors.grey,
  accentColor: Colors.pink,
  brightness: Brightness.light,
);

final ThemeData lightTheme = lightBaseTheme.copyWith(
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    ),
    contentPadding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
  ),
  buttonTheme: lightBaseTheme.buttonTheme.copyWith(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
  ),
  cardTheme: lightBaseTheme.cardTheme.copyWith(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    elevation: 4.0,
  ),
);
