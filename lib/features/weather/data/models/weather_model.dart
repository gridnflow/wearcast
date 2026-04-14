import 'package:flutter/foundation.dart';

import '../../domain/entities/weather.dart';

/// Data-layer model mirroring OpenWeatherMap's `/weather` response.
///
/// Kept separate from the domain [Weather] entity so API changes don't leak
/// into business logic. Use [toEntity] at the repository boundary.
@immutable
class WeatherModel {
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String main;
  final String description;
  final String icon;
  final double precipitation;
  final String cityName;
  final int dt;

  const WeatherModel({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.main,
    required this.description,
    required this.icon,
    required this.precipitation,
    required this.cityName,
    required this.dt,
  });

  /// Parses a response from `GET /data/2.5/weather`.
  factory WeatherModel.fromCurrentJson(Map<String, dynamic> json) {
    final mainMap = (json['main'] as Map?)?.cast<String, dynamic>() ?? {};
    final windMap = (json['wind'] as Map?)?.cast<String, dynamic>() ?? {};
    final weatherList = (json['weather'] as List?) ?? const [];
    final first = weatherList.isNotEmpty
        ? (weatherList.first as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    final rainMap = (json['rain'] as Map?)?.cast<String, dynamic>();
    final snowMap = (json['snow'] as Map?)?.cast<String, dynamic>();

    return WeatherModel(
      temp: _asDouble(mainMap['temp']),
      feelsLike: _asDouble(mainMap['feels_like']),
      humidity: _asInt(mainMap['humidity']),
      windSpeed: _asDouble(windMap['speed']),
      main: (first['main'] as String?) ?? '',
      description: (first['description'] as String?) ?? '',
      icon: (first['icon'] as String?) ?? '',
      precipitation: _asDouble(rainMap?['1h'] ?? snowMap?['1h']),
      cityName: (json['name'] as String?) ?? '',
      dt: _asInt(json['dt']),
    );
  }

  /// Parses a single list entry from `GET /data/2.5/forecast`.
  ///
  /// The forecast endpoint nests fields slightly differently (`dt_txt` is a
  /// string timestamp; the city name sits outside this object).
  factory WeatherModel.fromForecastEntry(
    Map<String, dynamic> json, {
    required String cityName,
  }) {
    final mainMap = (json['main'] as Map?)?.cast<String, dynamic>() ?? {};
    final windMap = (json['wind'] as Map?)?.cast<String, dynamic>() ?? {};
    final weatherList = (json['weather'] as List?) ?? const [];
    final first = weatherList.isNotEmpty
        ? (weatherList.first as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    final rainMap = (json['rain'] as Map?)?.cast<String, dynamic>();
    final snowMap = (json['snow'] as Map?)?.cast<String, dynamic>();

    return WeatherModel(
      temp: _asDouble(mainMap['temp']),
      feelsLike: _asDouble(mainMap['feels_like']),
      humidity: _asInt(mainMap['humidity']),
      windSpeed: _asDouble(windMap['speed']),
      main: (first['main'] as String?) ?? '',
      description: (first['description'] as String?) ?? '',
      icon: (first['icon'] as String?) ?? '',
      precipitation: _asDouble(rainMap?['3h'] ?? snowMap?['3h']),
      cityName: cityName,
      dt: _asInt(json['dt']),
    );
  }

  Weather toEntity() => Weather(
        temperature: temp,
        feelsLike: feelsLike,
        humidity: humidity,
        windSpeed: windSpeed,
        condition: main.toLowerCase(),
        description: description,
        icon: icon,
        precipitation: precipitation,
        cityName: cityName,
        dateTime: DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true)
            .toLocal(),
      );
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int _asInt(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
