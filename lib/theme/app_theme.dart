import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData build() {
    const marioRed = Color(0xFFE53935);
    const marioBlue = Color(0xFF1E88E5);
    const coinGold = Color(0xFFFBC02D);
    const pipeGreen = Color(0xFF43A047);
    const bgCream = Color(0xFFFFF8E1);

    final base = ThemeData(useMaterial3: true, colorSchemeSeed: marioRed);

    return base.copyWith(
      scaffoldBackgroundColor: bgCream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: marioRed,
        primary: marioRed,
        secondary: marioBlue,
        tertiary: coinGold,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: marioRed,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: pipeGreen.withValues(alpha: 0.12),
        selectedColor: pipeGreen,
      ),
      textTheme: base.textTheme.copyWith(
        headlineMedium: const TextStyle(fontWeight: FontWeight.w900),
        titleLarge: const TextStyle(fontWeight: FontWeight.w800),
        titleMedium: const TextStyle(fontWeight: FontWeight.w700),
        bodyLarge: const TextStyle(height: 1.35),
      ),
    );
  }
}
