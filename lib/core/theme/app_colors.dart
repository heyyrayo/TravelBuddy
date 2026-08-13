import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Primary ---
  static const Color primary = Color(0xFF002045);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1A365D);
  static const Color onPrimaryContainer = Color(0xFF86A0CD);
  static const Color inversePrimary = Color(0xFFADC7F7);

  // --- Secondary (Saffron/Marigold) — CTAs only ---
  static const Color secondary = Color(0xFF855300);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFEA619);
  static const Color onSecondaryContainer = Color(0xFF684000);

  // --- Tertiary (Teal) — supporting accents only ---
  static const Color tertiary = Color(0xFF002522);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF003D37);
  static const Color onTertiaryContainer = Color(0xFF3CAFA2);

  // --- Error ---
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // --- Background & Surface ---
  static const Color background = Color(0xFFFCF9F6);
  static const Color onBackground = Color(0xFF1C1C1A);
  static const Color surface = Color(0xFFFCF9F6);
  static const Color onSurface = Color(0xFF1C1C1A);
  static const Color surfaceDim = Color(0xFFDCDAD7);
  static const Color surfaceBright = Color(0xFFFCF9F6);

  // --- Surface containers (tonal steps) ---
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F0);
  static const Color surfaceContainer = Color(0xFFF0EDEA);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E5);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DF);
  static const Color surfaceVariant = Color(0xFFE5E2DF);

  // --- On-surface variants ---
  static const Color onSurfaceVariant = Color(0xFF43474E);
  static const Color outline = Color(0xFF74777F);
  static const Color outlineVariant = Color(0xFFC4C6CF);

  // --- Inverse ---
  static const Color inverseSurface = Color(0xFF31302F);
  static const Color inverseOnSurface = Color(0xFFF3F0ED);

  // --- Fixed ---
  static const Color primaryFixed = Color(0xFFD6E3FF);
  static const Color primaryFixedDim = Color(0xFFADC7F7);
  static const Color onPrimaryFixed = Color(0xFF001B3C);
  static const Color onPrimaryFixedVariant = Color(0xFF2D476F);

  static const Color secondaryFixed = Color(0xFFFFDDB8);
  static const Color secondaryFixedDim = Color(0xFFFFB95F);
  static const Color onSecondaryFixed = Color(0xFF2A1700);
  static const Color onSecondaryFixedVariant = Color(0xFF653E00);

  static const Color tertiaryFixed = Color(0xFF89F5E7);
  static const Color tertiaryFixedDim = Color(0xFF6BD8CB);
  static const Color onTertiaryFixed = Color(0xFF00201D);
  static const Color onTertiaryFixedVariant = Color(0xFF005049);

  // --- Surface tint ---
  static const Color surfaceTint = Color(0xFF455F88);

  // --- Level-2 elevation shadow ---
  static List<BoxShadow> get level2Shadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
