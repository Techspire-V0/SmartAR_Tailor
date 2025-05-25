import 'package:SmartAR/data/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: textPrimary,
    tertiary: textSecondary,
    surface: Colors.white,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: primaryColor),
    bodyMedium: TextStyle(color: textSecondary),
    bodySmall: TextStyle(color: Colors.black54),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white, elevation: 0),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  // More light theme properties here
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.white,
    tertiary: Colors.white,
    surface: primaryColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: primaryColor),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black, elevation: 0),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
  // More dark theme properties here
);

class ThemeProvider extends StateNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.light);

  ThemeMode get themeMode => state;

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
