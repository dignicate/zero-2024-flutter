import 'package:flutter/material.dart';

extension ThemeDataExtension on ThemeData {
  Color get appBarBackground => const Color(0xFF000000);
  Color get appBarTitle => const Color(0xFFFFFFFF);
}

extension TextThemeExtensions on TextTheme {
  TextStyle appBarTitle({required Color? color}) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: color,
    );
  }
}
