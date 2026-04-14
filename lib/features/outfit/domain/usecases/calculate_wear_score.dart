import '../entities/outfit.dart';
import '../../../weather/domain/entities/weather.dart';

/// Pure, side-effect-free engine that converts raw weather into two primitives
/// consumed by the outfit recommender:
///
/// 1. An **apparent temperature** (°C) combining dry-bulb temperature,
///    humidity and wind chill.
/// 2. A 0–100 **wear score** where 0 = dress as lightly as possible and
///    100 = dress as warmly as possible.
///
/// The formulas used here are intentionally simple so they can be unit-tested
/// deterministically — see [apparentTemperature] for the exact equation.
class CalculateWearScore {
  const CalculateWearScore();

  /// Upper anchor of the linear score mapping (°C). At this apparent
  /// temperature the wear score is 0.
  static const double _hotAnchor = 30.0;

  /// Lower anchor of the linear score mapping (°C). At this apparent
  /// temperature the wear score is 100.
  static const double _coldAnchor = 0.0;

  /// Below this temperature wind is treated as a cold-stress factor.
  static const double _windChillCutoff = 10.0;

  /// Apparent (feels-like) temperature in °C.
  ///
  /// ```text
  /// feelsLike = T - 0.55 * (1 - H/100) * (T - 14.5) - windChill(T, v)
  /// ```
  ///
  /// The first correction is the AT (Apparent Temperature) humidity term
  /// from the Australian Bureau of Meteorology — it pulls the value down
  /// when air is dry and warm. The wind chill component only activates for
  /// cool weather (T ≤ 10°C) because breeze has negligible cooling impact
  /// when the air is warmer than skin.
  double apparentTemperature({
    required double temperature,
    required int humidity,
    required double windSpeed,
  }) {
    final humidityFactor = 1 - humidity / 100.0;
    final humidityTerm = 0.55 * humidityFactor * (temperature - 14.5);
    final windChill = temperature <= _windChillCutoff ? 0.5 * windSpeed : 0.0;
    return temperature - humidityTerm - windChill;
  }

  /// Maps an apparent temperature in °C to an [OutfitCategory] tier.
  OutfitCategory categorize(double apparentC) {
    if (apparentC >= 28) return OutfitCategory.extremeHot;
    if (apparentC >= 23) return OutfitCategory.hot;
    if (apparentC >= 20) return OutfitCategory.warm;
    if (apparentC >= 17) return OutfitCategory.mild;
    if (apparentC >= 12) return OutfitCategory.cool;
    if (apparentC >= 9) return OutfitCategory.chilly;
    if (apparentC >= 5) return OutfitCategory.cold;
    return OutfitCategory.extremeCold;
  }

  /// Same as [categorize] but incorporates the user's [sensitivity] offset.
  ///
  /// Positive [sensitivity] means the user runs warm (feels `sensitivity` °C
  /// above average) — we therefore push them into a lighter tier by *adding*
  /// the offset before categorizing. Negative values do the opposite.
  OutfitCategory categorizeForUser(
    Weather weather, {
    double sensitivity = 0.0,
  }) {
    final apparent = apparentTemperature(
      temperature: weather.temperature,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
    );
    return categorize(apparent + sensitivity);
  }

  /// Computes the 0–100 wear score for [weather] given the user's
  /// [sensitivity] offset in °C.
  int call(Weather weather, {double sensitivity = 0.0}) {
    final apparent = apparentTemperature(
      temperature: weather.temperature,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
    );
    final adjusted = apparent + sensitivity;

    // Linear interpolation: _hotAnchor → 0, _coldAnchor → 100.
    const span = _hotAnchor - _coldAnchor;
    final raw = ((_hotAnchor - adjusted) / span) * 100.0;
    return raw.clamp(0.0, 100.0).round();
  }
}
