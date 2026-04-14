import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography tokens for WearCast.
///
/// We pair two Google Fonts:
///  * **Quicksand** — friendly, rounded sans-serif used for the majority of UI
///    copy. It fits the hand-drawn illustration style.
///  * **Fraunces** — a soft, slightly whimsical display serif used for hero
///    numbers (e.g. the big temperature reading on the home screen).
class AppTypography {
  AppTypography._();

  /// Display / hero numbers and screen titles.
  static TextStyle get displayLarge => GoogleFonts.fraunces(
        fontSize: 64,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.2,
        height: 1.05,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.fraunces(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        height: 1.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.fraunces(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.15,
        color: AppColors.textPrimary,
      );

  // Headings.
  static TextStyle get headlineLarge => GoogleFonts.quicksand(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.quicksand(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.quicksand(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  // Titles (used inside cards and sheets).
  static TextStyle get titleLarge => GoogleFonts.quicksand(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  // Body.
  static TextStyle get bodyLarge => GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.quicksand(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: AppColors.textTertiary,
      );

  // Labels / buttons / overlines.
  static TextStyle get labelLarge => GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.quicksand(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.2,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => GoogleFonts.quicksand(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        height: 1.2,
        color: AppColors.textTertiary,
      );

  /// Flutter [TextTheme] assembled from the individual tokens above.
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
