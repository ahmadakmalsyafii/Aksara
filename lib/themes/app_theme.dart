import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// Warna utama aplikasi
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  /// Shadow standar
  static final List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  /// ThemeData utama
  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryColor,
    ),

    /// Text Theme pakai Google Fonts Inter
    textTheme: GoogleFonts.interTextTheme().copyWith(
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
      bodySmall: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),

    /// ElevatedButton style global
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    ),

    /// Input (untuk search bar, textfield, dll)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    ),
  );
}
