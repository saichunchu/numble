import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const background = Color(0xFF07070D);
  static const backgroundMid = Color(0xFF0E0E18);
  static const surface = Color(0xFF14141F);
  static const surfaceElevated = Color(0xFF1C1C2A);
  static const surfaceGlass = Color(0xCC161622);
  static const border = Color(0xFF2E2E42);
  static const borderLight = Color(0xFF3D3D56);

  static const textPrimary = Color(0xFFF4F4F8);
  static const textSecondary = Color(0xFF9898B0);
  static const textMuted = Color(0xFF6B6B82);

  static const emerald = Color(0xFF34D399);
  static const emeraldDark = Color(0xFF059669);
  static const emeraldGlow = Color(0x4034D399);

  static const gold = Color(0xFFFBBF24);
  static const goldDark = Color(0xFFD97706);
  static const goldGlow = Color(0x40FBBF24);

  static const amethyst = Color(0xFFA78BFA);
  static const amethystDark = Color(0xFF7C3AED);
  static const amethystGlow = Color(0x40A78BFA);

  static const coral = Color(0xFFF87171);
  static const coralDark = Color(0xFFDC2626);

  static const slate = Color(0xFF64748B);
  static const slateDark = Color(0xFF475569);

  static const correct = Color(0xFF10B981);
  static const correctDark = Color(0xFF047857);
  static const present = Color(0xFFF59E0B);
  static const presentDark = Color(0xFFB45309);
  static const absent = Color(0xFF475569);
  static const absentDark = Color(0xFF334155);

  static const keyDefault = Color(0xFF2A2A3C);
  static const keyDefaultShadow = Color(0xFF1A1A28);
  static const keyAction = Color(0xFF222233);
  static const keyActionShadow = Color(0xFF14141F);
}

abstract final class AppTheme {
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.syne(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.1,
      );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.syne(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 1.5,
      );

  static TextStyle headline(BuildContext context) => GoogleFonts.syne(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle title(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle body(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle label(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.8,
      );

  static TextStyle statValue(BuildContext context) => GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle tileDigit(double size) => GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle keyLabel(double size) => GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.3,
      );

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emerald,
        secondary: AppColors.amethyst,
        surface: AppColors.surface,
        error: AppColors.coral,
        onPrimary: AppColors.background,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
        titleTextStyle: GoogleFonts.syne(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 2,
        ),
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textSecondary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }

  static BoxDecoration glassCard({double radius = 20}) => BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration gradientBorder({double radius = 16}) => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          colors: [
            AppColors.amethyst,
            AppColors.emerald,
            AppColors.gold,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [AppColors.emerald, AppColors.emeraldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient accentGradient = const LinearGradient(
    colors: [AppColors.amethyst, AppColors.amethystDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient titleGradient = const LinearGradient(
    colors: [AppColors.textPrimary, AppColors.amethyst, AppColors.emerald],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
