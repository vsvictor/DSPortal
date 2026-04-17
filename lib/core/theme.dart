import 'package:flutter/material.dart';

class DsColors {
  static const Color blue = Color(0xFF0057B7);
  static const Color yellow = Color(0xFFFFD700);
  static const Color white = Colors.white;
  static const Color text = Color(0xFF1B1F23);
}

ThemeData buildPortalTheme() {
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: DsColors.blue,
    primary: DsColors.blue,
    secondary: DsColors.yellow,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF6F8FC),
    appBarTheme: const AppBarTheme(
      backgroundColor: DsColors.blue,
      foregroundColor: DsColors.white,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      color: DsColors.white,
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}

