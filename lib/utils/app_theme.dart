import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core palette — gentle pastels for mindfulness aesthetics
  static const Color primaryColor = Color(0xFF8A8DFF); // Lavender-Blue
  static const Color secondaryColor = Color(0xFF63E6BE); // Sky-Teal
  static const Color accentColor = Color(0xFFFFC8A2); // Soft Peach
  static const Color backgroundColor = Color(0xFFFAFAFA); // Off-White
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0F3FF);
  static const Color textPrimaryColor = Color(0xFF1D1E33);
  static const Color textSecondaryColor = Color(0xFF66708D);
  static const Color successColor = Color(0xFF7CDDBA);
  static const Color warningColor = Color(0xFFFFD17E);
  static const Color errorColor = Color(0xFFE76F51);

  static const LinearGradient defaultGradient = LinearGradient(
    colors: [Color(0xFF8A8DFF), Color(0xFF63E6BE), Color(0xFFFAFAFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      bodyColor: textPrimaryColor,
      displayColor: textPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textPrimaryColor),
      titleTextStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      focusElevation: 8,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shadowColor: primaryColor.withOpacity(0.3),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: Color(0xFFCED2FF), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 8,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryColor, width: 1.8),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      hintStyle: const TextStyle(color: Color(0xFF9AA0BC)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceMuted,
      selectedColor: primaryColor.withOpacity(0.18),
      disabledColor: surfaceMuted.withOpacity(0.4),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: surfaceColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
      ),
      contentTextStyle: const TextStyle(
        fontSize: 15,
        color: textSecondaryColor,
        height: 1.5,
      ),
    ),
    dividerTheme: const DividerThemeData(
      space: 32,
      thickness: 1,
      color: Color(0xFFE4E7FF),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: const Color(0xFFB8B9FF),
      secondary: const Color(0xFF787DFF),
      background: const Color(0xFF1A1A2E), // Dark Navy
      surface: const Color(0xFF171A34),
      error: const Color(0xFFFF8A80),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Dark Navy
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: const Color(0xFFECEEFF),
      displayColor: const Color(0xFFECEEFF),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white70),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1A1E3F),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF7D82FF),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA3A9FF),
        foregroundColor: const Color(0xFF14173A),
        elevation: 4,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1E3F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF7D82FF), width: 1.8),
      ),
      labelStyle: const TextStyle(color: Color(0xFFB7BCFF)),
    ),
  );

  static LinearGradient moodGradient(String moodTag) {
    switch (moodTag) {
      case 'sad':
        return const LinearGradient(
          colors: [Color(0xFF8A8DFF), Color(0xFFA8C8FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'anxious':
        return const LinearGradient(
          colors: [Color(0xFF63E6BE), Color(0xFF8A8DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'angry':
        return const LinearGradient(
          colors: [Color(0xFFFFC8A2), Color(0xFFFF9A7B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'happy':
        return const LinearGradient(
          colors: [Color(0xFFFFC8A2), Color(0xFF8A8DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'calm':
        return const LinearGradient(
          colors: [Color(0xFF63E6BE), Color(0xFF8A8DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return defaultGradient;
    }
  }
}