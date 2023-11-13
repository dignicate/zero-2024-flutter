import 'package:flutter/material.dart';

extension ThemeDataExtension on ThemeData {
  Color get navigationBackground=> const Color(0xFF9FB9D0);
}

extension TextThemeExtensions on TextTheme {
  TextStyle get appBarTitle => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}
