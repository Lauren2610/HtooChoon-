import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // ============================================================
  // COLORS - Soft, professional palette
  // ============================================================

  // Light Theme Colors
  static const _lightPrimary = Color(0xFF0F172A); // Slate 900
  static const _lightPrimaryVariant = Color(0xFF1E293B); // Slate 800
  static const _lightAccent = Color(0xFF3B82F6); // Blue 500
  static const _lightAccentVariant = Color(0xFF2563EB); // Blue 600

  static const _lightBackground = Color(0xFFFAFAFA); // Neutral 50
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightSurfaceVariant = Color(0xFFF5F5F5); // Neutral 100

  static const _lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const _lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const _lightTextTertiary = Color(0xFF94A3B8); // Slate 400

  static const _lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const _lightDivider = Color(0xFFF1F5F9); // Slate 100

  // Dark Theme Colors
  static const _darkPrimary = Color(0xFFF8FAFC); // Slate 50
  static const _darkPrimaryVariant = Color(0xFFE2E8F0); // Slate 200
  static const _darkAccent = Color(0xFF60A5FA); // Blue 400
  static const _darkAccentVariant = Color(0xFF3B82F6); // Blue 500

  static const _darkBackground = Color(0xFF0A0A0B); // Almost black
  static const _darkSurface = Color(0xFF141416); // Dark surface
  static const _darkSurfaceVariant = Color(0xFF1C1C1F); // Elevated surface

  static const _darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const _darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const _darkTextTertiary = Color(0xFF64748B); // Slate 500

  static const _darkBorder = Color(0xFF27272A); // Zinc 800
  static const _darkDivider = Color(0xFF1C1C1F);

  // Semantic Colors
  static const success = Color(0xFF10B981); // Green 500
  static const successLight = Color(0xFFD1FAE5); // Green 100
  static const warning = Color(0xFFF59E0B); // Amber 500
  static const warningLight = Color(0xFFFEF3C7); // Amber 100
  static const error = Color(0xFFEF4444); // Red 500
  static const errorLight = Color(0xFFFEE2E2); // Red 100
  static const info = Color(0xFF3B82F6); // Blue 500
  static const infoLight = Color(0xFFDBEAFE); // Blue 100

  // ============================================================
  // TYPOGRAPHY - Clean, modern font hierarchy
  // ============================================================

  static const String _fontFamily = 'Inter'; // or SF Pro, Geist

  static const TextTheme _baseTextTheme = TextTheme(
    // Display - Large headers
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.3,
    ),

    // Headlines
    headlineLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      height: 1.4,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),

    // Body
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
    ),

    // Labels
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: 0.1,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: 0.2,
    ),
  );

  // ============================================================
  // SPACING - Consistent spacing scale
  // ============================================================

  static const double space2xs = 4.0;
  static const double spaceXs = 8.0;
  static const double spaceSm = 12.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 40.0;
  static const double space3xl = 48.0;
  static const double space4xl = 64.0;

  // ============================================================
  // BORDER RADIUS - Soft, modern corners
  // ============================================================

  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radiusFull = 999.0;

  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadius2xl = BorderRadius.all(
    Radius.circular(radius2xl),
  );

  // ============================================================
  // SHADOWS - Subtle, layered elevation
  // ============================================================

  static List<BoxShadow> shadowSm(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMd(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.4)
          : Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.2)
          : Colors.black.withOpacity(0.03),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowLg(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.5)
          : Colors.black.withOpacity(0.1),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowXl(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.6)
          : Colors.black.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.4)
          : Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // ============================================================
  // THEME DATA
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: _lightAccent,
      primaryContainer: Color(0xFFEFF6FF), // Blue 50
      secondary: _lightPrimary,
      surface: _lightSurface,
      surfaceContainerHighest: _lightSurfaceVariant,
      background: _lightBackground,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _lightTextPrimary,
      onBackground: _lightTextPrimary,
      outline: _lightBorder,
    ),

    scaffoldBackgroundColor: _lightBackground,

    textTheme: _baseTextTheme.apply(
      bodyColor: _lightTextPrimary,
      displayColor: _lightTextPrimary,
    ),

    // cardTheme: CardTheme(
    //   elevation: 0,
    //   color: _lightSurface,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: borderRadiusLg,
    //     side: BorderSide(color: _lightBorder, width: 1),
    //   ),
    //   margin: EdgeInsets.zero,
    // ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: _lightSurface,
      foregroundColor: _lightTextPrimary,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _lightTextPrimary,
        letterSpacing: -0.1,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _lightAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceSm,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _lightTextPrimary,
        side: const BorderSide(color: _lightBorder, width: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceSm,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightAccent,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceSm,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spaceMd,
        vertical: spaceSm,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: _lightBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: _lightBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: _lightAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: error, width: 1),
      ),
      labelStyle: const TextStyle(fontSize: 14, color: _lightTextSecondary),
    ),

    dividerTheme: const DividerThemeData(
      color: _lightDivider,
      thickness: 1,
      space: 1,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _lightSurfaceVariant,
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _lightTextPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spaceSm,
        vertical: space2xs,
      ),
      shape: RoundedRectangleBorder(borderRadius: borderRadiusSm),
      side: BorderSide.none,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightAccent,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: borderRadiusLg),
    ),

    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: _lightSurface,
      selectedIconTheme: IconThemeData(color: _lightAccent, size: 24),
      unselectedIconTheme: IconThemeData(color: _lightTextSecondary, size: 24),
      selectedLabelTextStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _lightAccent,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: _lightTextSecondary,
      ),
      indicatorColor: Color(0xFFEFF6FF), // Blue 50
      useIndicator: true,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: _darkAccent,
      primaryContainer: Color(0xFF1E3A8A), // Blue 900
      secondary: _darkPrimary,
      surface: _darkSurface,
      surfaceContainerHighest: _darkSurfaceVariant,
      background: _darkBackground,
      error: error,
      onPrimary: _darkBackground,
      onSecondary: _darkBackground,
      onSurface: _darkTextPrimary,
      onBackground: _darkTextPrimary,
      outline: _darkBorder,
    ),

    scaffoldBackgroundColor: _darkBackground,

    textTheme: _baseTextTheme.apply(
      bodyColor: _darkTextPrimary,
      displayColor: _darkTextPrimary,
    ),

    // cardTheme: CardTheme(
    //   elevation: 0,
    //   color: _darkSurface,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: borderRadiusLg,
    //     side: BorderSide(color: _darkBorder, width: 1),
    //   ),
    //   margin: EdgeInsets.zero,
    // ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: _darkSurface,
      foregroundColor: _darkTextPrimary,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _darkTextPrimary,
        letterSpacing: -0.1,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _darkAccent,
        foregroundColor: _darkBackground,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceSm,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkTextPrimary,
        side: const BorderSide(color: _darkBorder, width: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceSm,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkAccent,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceSm,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spaceMd,
        vertical: spaceSm,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: _darkBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: _darkBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: _darkAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadiusMd,
        borderSide: const BorderSide(color: error, width: 1),
      ),
      labelStyle: const TextStyle(fontSize: 14, color: _darkTextSecondary),
    ),

    dividerTheme: const DividerThemeData(
      color: _darkDivider,
      thickness: 1,
      space: 1,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _darkSurfaceVariant,
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _darkTextPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spaceSm,
        vertical: space2xs,
      ),
      shape: RoundedRectangleBorder(borderRadius: borderRadiusSm),
      side: BorderSide.none,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkAccent,
      foregroundColor: _darkBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: borderRadiusLg),
    ),

    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: _darkSurface,
      selectedIconTheme: IconThemeData(color: _darkAccent, size: 24),
      unselectedIconTheme: IconThemeData(color: _darkTextSecondary, size: 24),
      selectedLabelTextStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _darkAccent,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: _darkTextSecondary,
      ),
      indicatorColor: Color(0xFF1E3A8A), // Blue 900
      useIndicator: true,
    ),
  );

  // ============================================================
  // HELPER GETTERS
  // ============================================================

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightTextSecondary
        : _darkTextSecondary;
  }

  static Color getTextTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightTextTertiary
        : _darkTextTertiary;
  }

  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightBorder
        : _darkBorder;
  }

  static Color getSurfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightSurfaceVariant
        : _darkSurfaceVariant;
  }
}
