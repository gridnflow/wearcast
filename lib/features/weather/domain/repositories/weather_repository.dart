import '../../../../core/utils/result.dart';
import '../entities/forecast.dart';
import '../entities/weather.dart';

/// Contract for retrieving weather data. Implemented in the data layer
/// (Phase 5) and consumed by use cases.
abstract class WeatherRepository {
  /// Current weather for the given geographic coordinates.
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  });

  /// Multi-day forecast for the given geographic coordinates.
  Future<Result<Forecast>> getForecast({
    required double latitude,
    required double longitude,
  });
}
