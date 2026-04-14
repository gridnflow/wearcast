/// Centralized spacing, radius and elevation tokens used across the app.
///
/// We follow a 4px base grid. Prefer these constants over raw numeric
/// literals so the visual rhythm stays consistent.
class AppSpacing {
  AppSpacing._();

  // Base grid (4px).
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xl2 = 24;
  static const double xl3 = 32;
  static const double xl4 = 40;
  static const double xl5 = 48;
  static const double xl6 = 64;

  // Component-level defaults.
  static const double screenPadding = 20;
  static const double cardPadding = 20;
  static const double sectionGap = 24;
}

/// Corner radii — the app leans heavily on soft, rounded shapes to match the
/// hand-drawn illustration style.
class AppRadius {
  AppRadius._();

  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double xl2 = 36;
  static const double pill = 999;
}

/// Elevation (blur + Y offset) tokens for drop shadows and glass surfaces.
class AppElevation {
  AppElevation._();

  static const double none = 0;
  static const double sm = 4;
  static const double md = 10;
  static const double lg = 20;
  static const double xl = 32;

  /// Default blur sigma for Glassmorphism backdrop filters.
  static const double glassBlur = 18;
}

/// Duration tokens for motion. Keep transitions short and snappy.
class AppDuration {
  AppDuration._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration weatherTransition = Duration(milliseconds: 800);
}
