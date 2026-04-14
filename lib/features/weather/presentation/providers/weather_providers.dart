import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';

/// DI: use cases built on top of the repository provider.
final getCurrentWeatherProvider = Provider<GetCurrentWeather>((ref) {
  final repo = ref.watch(weatherRepositoryProvider);
  return GetCurrentWeather(repo);
});

final getForecastProvider = Provider<GetForecast>((ref) {
  final repo = ref.watch(weatherRepositoryProvider);
  return GetForecast(repo);
});

/// Arguments for the coordinate-based providers below.
///
/// Defined as a value type so Riverpod's `.family` can cache per
/// (lat, lon) pair. Rounded to 4 decimal places (~11m precision) to avoid
/// creating distinct cache entries for tiny GPS jitter.
class WeatherQuery {
  final double latitude;
  final double longitude;

  WeatherQuery({required double latitude, required double longitude})
      : latitude = _round(latitude),
        longitude = _round(longitude);

  static double _round(double v) => (v * 10000).roundToDouble() / 10000;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherQuery &&
          other.latitude == latitude &&
          other.longitude == longitude);

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'WeatherQuery(lat: $latitude, lon: $longitude)';
}

/// Async state: current weather for a given coordinate.
final currentWeatherProvider =
    FutureProvider.family<Weather, WeatherQuery>((ref, query) async {
  final useCase = ref.watch(getCurrentWeatherProvider);
  final result = await useCase(
    GetCurrentWeatherParams(
      latitude: query.latitude,
      longitude: query.longitude,
    ),
  );
  return switch (result) {
    Ok<Weather>(value: final v) => v,
    Err<Weather>(failure: final f) => throw _FailureException(f.message),
  };
});

/// Async state: multi-day forecast for a given coordinate.
final forecastProvider =
    FutureProvider.family<Forecast, WeatherQuery>((ref, query) async {
  final useCase = ref.watch(getForecastProvider);
  final result = await useCase(
    GetForecastParams(
      latitude: query.latitude,
      longitude: query.longitude,
    ),
  );
  return switch (result) {
    Ok<Forecast>(value: final v) => v,
    Err<Forecast>(failure: final f) => throw _FailureException(f.message),
  };
});

/// Private exception type so [AsyncError] surfaces a human-readable message.
///
/// We intentionally don't expose this outside the provider layer; UI should
/// read `asyncValue.error?.toString()` for display.
class _FailureException implements Exception {
  final String message;
  const _FailureException(this.message);

  @override
  String toString() => message;
}
