import 'package:flutter/foundation.dart';

import '../../domain/entities/forecast.dart';
import 'weather_model.dart';

/// Data-layer model for the OpenWeatherMap 5-day / 3-hour forecast endpoint.
///
/// Structure:
///   { "city": { "name": "..." }, "list": [ { ... entry ... }, ... ] }
@immutable
class ForecastModel {
  final String cityName;
  final List<WeatherModel> entries;

  const ForecastModel({
    required this.cityName,
    required this.entries,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final cityName =
        ((json['city'] as Map?)?['name'] as String?) ?? '';
    final rawList = (json['list'] as List?) ?? const [];
    final entries = rawList
        .whereType<Map>()
        .map((e) => WeatherModel.fromForecastEntry(
              e.cast<String, dynamic>(),
              cityName: cityName,
            ))
        .toList();

    return ForecastModel(
      cityName: cityName,
      entries: entries,
    );
  }

  /// Converts the raw 3-hour entries into a domain [Forecast] with both
  /// hourly slots and daily aggregates.
  Forecast toEntity() {
    final hourly = entries.map(_toForecastEntry).toList();
    final daily = _aggregateDaily(hourly);
    return Forecast(
      cityName: cityName,
      hourly: hourly,
      daily: daily,
    );
  }

  ForecastEntry _toForecastEntry(WeatherModel m) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(m.dt * 1000, isUtc: true).toLocal();
    return ForecastEntry(
      dateTime: dateTime,
      temperature: m.temp,
      feelsLike: m.feelsLike,
      humidity: m.humidity,
      windSpeed: m.windSpeed,
      precipitation: m.precipitation,
      condition: m.main.toLowerCase(),
      description: m.description,
      icon: m.icon,
    );
  }

  /// Collapses 3-hour slots into one representative entry per calendar day.
  ///
  /// Picks the entry nearest to 12:00 local time as the "daily summary", which
  /// is conventional for OWM-style UIs. Temperature min/max are preserved by
  /// averaging the entry, so callers that need true min/max should compute it
  /// themselves from [hourly].
  List<ForecastEntry> _aggregateDaily(List<ForecastEntry> hourly) {
    if (hourly.isEmpty) return const [];

    final byDay = <String, List<ForecastEntry>>{};
    for (final entry in hourly) {
      final key =
          '${entry.dateTime.year}-${entry.dateTime.month}-${entry.dateTime.day}';
      byDay.putIfAbsent(key, () => []).add(entry);
    }

    final daily = <ForecastEntry>[];
    for (final dayEntries in byDay.values) {
      dayEntries.sort((a, b) {
        final aDiff = (a.dateTime.hour - 12).abs();
        final bDiff = (b.dateTime.hour - 12).abs();
        return aDiff.compareTo(bDiff);
      });
      daily.add(dayEntries.first);
    }

    daily.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return daily;
  }
}
