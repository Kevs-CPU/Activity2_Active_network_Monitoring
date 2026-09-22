import 'package:flutter/material.dart';

// ============================================================
// ACTIVITY 3
// App Theme
//
// Professional dark-gray Material 3 theme.
// ============================================================

class AppTheme {
  // ============================================================
  // LIGHT THEME
  // Existing light theme is kept simple.
  // ============================================================

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFFF5F6FA),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
    ),
  );

  // ============================================================
  // ACTIVITY 3
  // PROFESSIONAL DARK THEME
  // ============================================================

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    // ----------------------------------------------------------
    // ACTIVITY 3
    // Dark gray color system
    // ----------------------------------------------------------

    scaffoldBackgroundColor: const Color(0xFF151719),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF35C7C9),
      secondary: Color(0xFF35C7C9),

      surface: Color(0xFF202326),

      onSurface: Color(0xFFF2F4F5),

      outline: Color(0xFF303438),
    ),

    // ----------------------------------------------------------
    // ACTIVITY 3
    // AppBar
    // ----------------------------------------------------------

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Color(0xFF151719),
      foregroundColor: Color(0xFFF2F4F5),
    ),

    // ----------------------------------------------------------
    // ACTIVITY 3
    // Cards
    // ----------------------------------------------------------

    cardTheme: CardThemeData(
      color: const Color(0xFF202326),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF303438),
          width: 1,
        ),
      ),
    ),

    // ----------------------------------------------------------
    // ACTIVITY 3
    // Buttons
    // ----------------------------------------------------------

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF35C7C9),
        foregroundColor: const Color(0xFF101314),
        elevation: 0,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // ----------------------------------------------------------
    // ACTIVITY 3
    // Progress indicator
    // ----------------------------------------------------------

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF35C7C9),
      linearTrackColor: Color(0xFF303438),
    ),

    // ----------------------------------------------------------
    // ACTIVITY 3
    // Divider
    // ----------------------------------------------------------

    dividerTheme: const DividerThemeData(
      color: Color(0xFF303438),
      thickness: 1,
    ),
  );
}