import 'package:flutter/material.dart';

class SynqTheme {
  static const Color bg = Color(0xFFF0FAF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFC2E8E2);
  static const Color borderSoft = Color(0xFFD6F0EB);
  static const Color fill = Color(0xFFE4F7F3);

  static const Color primary = Color(0xFF0E7A6E);
  static const Color primaryMid = Color(0xFF3ABFB5);
  static const Color primaryDk = Color(0xFF0A3D37);

  static const Color textMain = Color(0xFF0A3D37);
  static const Color textMuted = Color(0xFF5AADA0);
  static const Color textSoft = Color(0xFF7AB8B0);

  static ThemeData build() {
    return ThemeData(
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textMain,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: textMain,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: textMain,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(color: textMuted, fontSize: 13),
        bodySmall: TextStyle(color: textSoft, fontSize: 11),
      ),
    );
  }
}
