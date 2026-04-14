import 'package:flutter/material.dart';

/// WearCast color palette.
///
/// The app uses weather-driven gradient palettes to evoke the mood of each
/// condition. Colors are chosen to feel hand-drawn, warm, and approachable —
/// paired with a Glassmorphism surface style.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Brand / neutral
  // ---------------------------------------------------------------------------

  /// Primary brand accent — used for CTAs and highlights.
  static const Color primary = Color(0xFFFF8A65); // Coral
  static const Color primaryDark = Color(0xFFE8633C);
  static const Color secondary = Color(0xFF7C9EFF); // Soft periwinkle
  static const Color accent = Color(0xFFFFD166); // Sunshine yellow

  static const Color background = Color(0xFFFDF8F3); // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3EEE7);

  static const Color textPrimary = Color(0xFF22223B);
  static const Color textSecondary = Color(0xFF55556E);
  static const Color textTertiary = Color(0xFF8A8AA0);
  static const Color textOnDark = Color(0xFFFFFFFF);

  static const Color divider = Color(0x1A22223B); // 10% textPrimary
  static const Color shadow = Color(0x1A000000);

  static const Color success = Color(0xFF4CC38A);
  static const Color warning = Color(0xFFFFB454);
  static const Color error = Color(0xFFE5484D);
  static const Color info = Color(0xFF5EB3F5);

  // ---------------------------------------------------------------------------
  // Glassmorphism
  // ---------------------------------------------------------------------------

  /// Fill for glass surfaces over colorful backgrounds.
  static const Color glassFill = Color(0x33FFFFFF); // white @ 20%
  static const Color glassFillStrong = Color(0x4DFFFFFF); // white @ 30%
  static const Color glassBorder = Color(0x66FFFFFF); // white @ 40%
  static const Color glassShadow = Color(0x1F000000);

  // ---------------------------------------------------------------------------
  // Weather gradients
  //
  // Each palette is ordered top → bottom for a vertical gradient background.
  // ---------------------------------------------------------------------------

  /// Sunny & warm — apricot → coral → sunshine.
  static const List<Color> sunnyWarm = [
    Color(0xFFFFD5A5), // apricot
    Color(0xFFFFA07A), // coral
    Color(0xFFFFD166), // sunshine yellow
  ];

  /// Sunny & mild — soft gold → pale peach → cream.
  static const List<Color> sunnyMild = [
    Color(0xFFFFE5B4),
    Color(0xFFFFCBA4),
    Color(0xFFFFF4E0),
  ];

  /// Cold — mint → lavender → deep navy.
  static const List<Color> cold = [
    Color(0xFFB8E6D3), // mint green
    Color(0xFFC3B6E8), // lavender
    Color(0xFF2E3A6B), // deep navy
  ];

  /// Cloudy — cool greys with a hint of lilac.
  static const List<Color> cloudy = [
    Color(0xFFD9E2EC),
    Color(0xFFB6C2D1),
    Color(0xFFA3A5C2),
  ];

  /// Rainy — blue grey → soft purple.
  static const List<Color> rainy = [
    Color(0xFF7A95B8), // blue grey
    Color(0xFF8A7FB5), // soft purple
    Color(0xFF4E5A7A),
  ];

  /// Snowy — icy white → pale blue → periwinkle.
  static const List<Color> snowy = [
    Color(0xFFF4F8FC),
    Color(0xFFD6E4F2),
    Color(0xFFA9BEDB),
  ];

  /// Dust / fine-particulate — muted ochre → dusty rose → warm grey.
  static const List<Color> dust = [
    Color(0xFFDFC9A3),
    Color(0xFFC9A890),
    Color(0xFF8C7B70),
  ];

  /// Night — indigo → plum → midnight.
  static const List<Color> night = [
    Color(0xFF3B2D66),
    Color(0xFF2A2350),
    Color(0xFF11122B),
  ];

  /// Returns the gradient palette that matches a semantic weather key.
  ///
  /// Accepted keys: `sunny_warm`, `sunny_mild`, `cold`, `cloudy`, `rainy`,
  /// `snowy`, `dust`, `night`. Falls back to [sunnyMild].
  static List<Color> gradientFor(String key) {
    switch (key) {
      case 'sunny_warm':
        return sunnyWarm;
      case 'sunny_mild':
        return sunnyMild;
      case 'cold':
        return cold;
      case 'cloudy':
        return cloudy;
      case 'rainy':
        return rainy;
      case 'snowy':
        return snowy;
      case 'dust':
        return dust;
      case 'night':
        return night;
      default:
        return sunnyMild;
    }
  }

  // ---------------------------------------------------------------------------
  // Temperature category accents
  //
  // Mapped to the 8 temperature buckets defined in AppConstants.
  // ---------------------------------------------------------------------------

  static const Map<String, Color> temperatureAccent = {
    'extreme_hot': Color(0xFFFF5B5B),
    'hot': Color(0xFFFF8A65),
    'warm': Color(0xFFFFB454),
    'mild': Color(0xFFFFD166),
    'cool': Color(0xFFB8CE7C),
    'chilly': Color(0xFF7EC4CF),
    'cold': Color(0xFF6E8BC9),
    'extreme_cold': Color(0xFF4758A8),
  };

  /// Returns the accent color for a temperature category, or [primary] as
  /// a safe fallback.
  static Color accentForCategory(String category) {
    return temperatureAccent[category] ?? primary;
  }
}
