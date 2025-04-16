import 'package:flutter/material.dart';

/// Centralized theme configuration for the app
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF1E3A8A);
  static const Color darkAccentColor = Color(0xFFEF4444);
  static const Color darkBackgroundColor = Color(0xFF0F172A);
  static const Color darkCardColor = Color(0xFF1E293B);

  // Light theme colors
  static const Color lightPrimaryColor = Color(0xFF2563EB);
  static const Color lightAccentColor = Color(0xFFE11D48);
  static const Color lightBackgroundColor = Color(0xFFF8FAFC);
  static const Color lightCardColor = Color(0xFFFFFFFF);

  // Typography - Dark Theme
  static const TextStyle darkHeadlineStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle darkTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle darkBodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
  );

  // Typography - Light Theme
  static const TextStyle lightHeadlineStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1E293B),
  );

  static const TextStyle lightTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF334155),
  );

  static const TextStyle lightBodyStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF475569),
  );

  // Dark theme button style
  static final ButtonStyle darkButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: darkAccentColor,
    foregroundColor: Colors.white,
    elevation: 4,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  // Light theme button style
  static final ButtonStyle lightButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: lightAccentColor,
    foregroundColor: Colors.white,
    elevation: 2,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  // The dark theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: darkButtonStyle),
    cardTheme: CardTheme(
      color: darkCardColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkAccentColor,
      surface: darkCardColor,
      background: darkBackgroundColor,
    ),
    textTheme: TextTheme(
      headlineMedium: darkHeadlineStyle,
      titleLarge: darkTitleStyle,
      bodyLarge: darkBodyStyle,
    ),
  );

  // The light theme
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: lightButtonStyle),
    cardTheme: CardTheme(
      color: lightCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    colorScheme: ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightAccentColor,
      surface: lightCardColor,
      background: lightBackgroundColor,
    ),
    textTheme: TextTheme(
      headlineMedium: lightHeadlineStyle,
      titleLarge: lightTitleStyle,
      bodyLarge: lightBodyStyle,
    ),
  );
}
