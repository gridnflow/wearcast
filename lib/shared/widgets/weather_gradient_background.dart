import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// High-level semantic categories used to pick a weather gradient.
///
/// Screens typically derive one of these from the current weather state and
/// pass it to [WeatherGradientBackground].
enum WeatherMood {
  sunnyWarm,
  sunnyMild,
  cold,
  cloudy,
  rainy,
  snowy,
  dust,
  night,
}

extension WeatherMoodX on WeatherMood {
  String get key {
    switch (this) {
      case WeatherMood.sunnyWarm:
        return 'sunny_warm';
      case WeatherMood.sunnyMild:
        return 'sunny_mild';
      case WeatherMood.cold:
        return 'cold';
      case WeatherMood.cloudy:
        return 'cloudy';
      case WeatherMood.rainy:
        return 'rainy';
      case WeatherMood.snowy:
        return 'snowy';
      case WeatherMood.dust:
        return 'dust';
      case WeatherMood.night:
        return 'night';
    }
  }

  List<Color> get colors => AppColors.gradientFor(key);

  /// Text/icon color to use on top of this background.
  Color get contentColor {
    switch (this) {
      case WeatherMood.sunnyMild:
      case WeatherMood.sunnyWarm:
      case WeatherMood.snowy:
      case WeatherMood.cloudy:
        return const Color(0xFF1E2D4A);
      default:
        return const Color(0xFFFFFFFF);
    }
  }

  bool get isLight {
    switch (this) {
      case WeatherMood.sunnyMild:
      case WeatherMood.sunnyWarm:
      case WeatherMood.snowy:
      case WeatherMood.cloudy:
        return true;
      default:
        return false;
    }
  }
}

/// A full-bleed animated gradient background driven by the current weather
/// mood. Children render above the gradient, so callers typically stack
/// [GlassCard] surfaces on top.
class WeatherGradientBackground extends StatelessWidget {
  final WeatherMood mood;
  final Widget child;
  final Duration duration;

  /// Begin / end alignment of the gradient. Defaults to a slight diagonal so
  /// the palette reads as "sky above, horizon below".
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const WeatherGradientBackground({
    super.key,
    required this.mood,
    required this.child,
    this.duration = AppDuration.weatherTransition,
    this.begin = const Alignment(-0.2, -1),
    this.end = const Alignment(0.2, 1),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: mood.colors,
        ),
      ),
      child: child,
    );
  }
}
