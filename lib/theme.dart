import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBg = Color(0xFF0A192F);
  static const Color surfaceBg = Color(0xFF112240);
  static const Color cardBg = Color(0xFF1D3557);
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color textHeading = Color(0xFFCCD6F6);
  static const Color textBody = Color(0xFF8892B0);
  static const Color textMuted = Color(0xFF4F5D75);

  // Custom Box Decorations for Glassmorphism
  static BoxDecoration glassCardDecoration({Color? borderColor}) {
    return BoxDecoration(
      color: surfaceBg.withValues(alpha: 0.75),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor ?? accentCyan.withValues(alpha: 0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: primaryBg,
      primaryColor: accentGold,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: accentGold,
        secondary: accentCyan,
        surface: surfaceBg,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 72,
          fontWeight: FontWeight.w900,
          color: textHeading,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: textHeading,
          letterSpacing: -1.0,
        ),
        displaySmall: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textHeading,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textHeading,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: textBody,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textBody,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: textBody.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: textBody.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.redAccent, width: 2),
        ),
        labelStyle: TextStyle(color: textBody),
        hintStyle: TextStyle(color: textBody.withValues(alpha: 0.5)),
      ),
      cardTheme: CardThemeData(
        color: surfaceBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: textBody.withValues(alpha: 0.1), width: 1),
        ),
        elevation: 8,
      ),
    );
  }
}
