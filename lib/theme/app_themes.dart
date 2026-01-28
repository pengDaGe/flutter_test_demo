import 'package:flutter/material.dart';

/// 应用主题配置
class AppThemes {
  AppThemes._();

  // ----- 亮色模式配置 -----
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
      primary: const Color(0xFF6750A4),
      onPrimary: Colors.white,
      secondary: const Color(0xFF625B71),
      surface: const Color(0xFFFEF7FF),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6750A4),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF6750A4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // ----- 暗色模式配置 -----
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD0BCFF),
      brightness: Brightness.dark,
      primary: const Color(0xFFD0BCFF),
      onPrimary: const Color(0xFF381E72),
      secondary: const Color(0xFFCCC2DC),
      surface: const Color(0xFF141218),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF141218),
      foregroundColor: Color(0xFFE6E1E5),
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF381E72),
        backgroundColor: const Color(0xFFD0BCFF),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1D1B20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
