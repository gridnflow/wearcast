import 'package:flutter/foundation.dart';

/// Represents current weather conditions at a specific location and time.
@immutable
class Weather {
  /// Actual temperature in Celsius.
  final double temperature;

  /// Apparent (feels-like) temperature in Celsius.
  final double feelsLike;

  /// Relative humidity percentage (0-100).
  final int humidity;

  /// Wind speed in meters per second.
  final double windSpeed;

  /// High-level weather condition code (e.g. 'clear', 'rain', 'snow').
  final String condition;

  /// Human-readable description (e.g. '맑음').
  final String description;

  /// Icon code provided by the weather API.
  final String icon;

  /// Precipitation amount in millimeters (last hour).
  final double precipitation;

  /// Display name of the city / location.
  final String cityName;

  /// Timestamp the measurement was taken.
  final DateTime dateTime;

  const Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.icon,
    required this.precipitation,
    required this.cityName,
    required this.dateTime,
  });

  Weather copyWith({
    double? temperature,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    String? condition,
    String? description,
    String? icon,
    double? precipitation,
    String? cityName,
    DateTime? dateTime,
  }) {
    return Weather(
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      precipitation: precipitation ?? this.precipitation,
      cityName: cityName ?? this.cityName,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Weather &&
        other.temperature == temperature &&
        other.feelsLike == feelsLike &&
        other.humidity == humidity &&
        other.windSpeed == windSpeed &&
        other.condition == condition &&
        other.description == description &&
        other.icon == icon &&
        other.precipitation == precipitation &&
        other.cityName == cityName &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode => Object.hash(
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        condition,
        description,
        icon,
        precipitation,
        cityName,
        dateTime,
      );

  @override
  String toString() =>
      'Weather(temp: $temperature°C, feelsLike: $feelsLike°C, '
      'humidity: $humidity%, wind: ${windSpeed}m/s, condition: $condition, '
      'precipitation: ${precipitation}mm, city: $cityName)';
}
