import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF5F5EC);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color primary = Color(0xFF2E5B41);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color secondary = Color(0xFFD1E6D3);
  static const Color secondaryAlt = Color(0xFFC8E6C9);

  static const Color accentPaper = Color(0xFFFFF59D);
  static const Color accentPlastic = Color(0xFFB2DFDB);
  static const Color accentGlass = Color(0xFFBBDEFB);
  static const Color accentTrees = Color(0xFFE1BEE7);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6E6E6E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);

  static const Color highContrastBackground = Color(0xFF000000);
  static const Color highContrastText = Color(0xFFFFFFFF);
  static const Color highContrastPrimary = Color(0xFFFFEB3B);
}

class AppRadius {
  AppRadius._();
  static const double card = 24;
  static const double button = 24;
  static const double bottomSheet = 28;
}

class AppShadows {
  AppShadows._();
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        headlineMedium: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.nunito(fontSize: 15, color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary),
      ),
    );
  }

  static ThemeData get highContrastTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.highContrastBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.highContrastPrimary,
        secondary: AppColors.highContrastPrimary,
        surface: AppColors.highContrastBackground,
        onSurface: AppColors.highContrastText,
        error: Color(0xFFFF5252),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: AppColors.highContrastPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.highContrastPrimary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: AppColors.highContrastPrimary,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.highContrastText),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.highContrastText),
        bodyLarge: TextStyle(fontSize: 18, color: AppColors.highContrastText),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      ),
    );
  }
}