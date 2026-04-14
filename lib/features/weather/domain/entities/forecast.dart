import 'package:flutter/foundation.dart';

import 'weather.dart';

/// A single forecast entry for a specific point in time.
@immutable
class ForecastEntry {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final String condition;
  final String description;
  final String icon;

  const ForecastEntry({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.condition,
    required this.description,
    required this.icon,
  });

  /// Projects this forecast entry into a [Weather] snapshot, using [cityName]
  /// so the outfit engine can operate on the same shape as current-weather.
  Weather toWeather(String cityName) => Weather(
        temperature: temperature,
        feelsLike: feelsLike,
        humidity: humidity,
        windSpeed: windSpeed,
        condition: condition,
        description: description,
        icon: icon,
        precipitation: precipitation,
        cityName: cityName,
        dateTime: dateTime,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForecastEntry &&
        other.dateTime == dateTime &&
        other.temperature == temperature &&
        other.feelsLike == feelsLike &&
        other.humidity == humidity &&
        other.windSpeed == windSpeed &&
        other.precipitation == precipitation &&
        other.condition == condition &&
        other.description == description &&
        other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(
        dateTime,
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        precipitation,
        condition,
        description,
        icon,
      );
}

/// Aggregated weather forecast for a city.
///
/// [hourly] covers fine-grained short-term predictions; [daily] is the
/// per-day summary (typically 5–7 days). Either list may be empty if the
/// API does not provide that granularity.
@immutable
class Forecast {
  final String cityName;
  final List<ForecastEntry> hourly;
  final List<ForecastEntry> daily;

  const Forecast({
    required this.cityName,
    required this.hourly,
    required this.daily,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Forecast &&
        other.cityName == cityName &&
        listEquals(other.hourly, hourly) &&
        listEquals(other.daily, daily);
  }

  @override
  int get hashCode =>
      Object.hash(cityName, Object.hashAll(hourly), Object.hashAll(daily));
}
