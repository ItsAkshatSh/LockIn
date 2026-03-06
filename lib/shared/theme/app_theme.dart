import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeColor {
  deepPurple(Colors.deepPurple, 'Deep Purple'),
  teal(Colors.teal, 'Teal'),
  indigo(Colors.indigo, 'Indigo'),
  rose(Colors.pink, 'Rose');

  final Color color;
  final String label;
  const AppThemeColor(this.color, this.label);
}

class AppTheme {
  static ThemeData getTheme(AppThemeColor themeColor, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: themeColor.color,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      textTheme: brightness == Brightness.light 
          ? GoogleFonts.interTextTheme() 
          : GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: brightness == Brightness.light ? Colors.grey[100] : Colors.grey[900],
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.light ? Colors.grey[200] : Colors.grey[800],
        labelStyle: TextStyle(color: colorScheme.onSurface),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => getTheme(AppThemeColor.deepPurple, Brightness.light);
  static ThemeData get darkTheme => getTheme(AppThemeColor.deepPurple, Brightness.dark);
}
