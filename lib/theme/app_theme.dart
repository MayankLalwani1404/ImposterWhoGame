import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors matching the new aesthetics
  static const Color darkBackground = Color(0xFF161616); // Very dark charcoal
  static const Color cardColor = Color(0xFFE8E5D5); // Cream/Beige paper-like
  static const Color accentLimeGreen = Color(0xFFCCFF00); // Bright Lime Green
  static const Color darkText = Color(0xFF1A1A1A); // Almost black for cards
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: accentLimeGreen,
        secondary: cardColor,
        surface: darkBackground,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
        titleLarge: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: GoogleFonts.nunito(fontSize: 16, color: Colors.white70),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentLimeGreen,
          foregroundColor: darkText,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          elevation: 0,
        ),
      ),
    );
  }
}
