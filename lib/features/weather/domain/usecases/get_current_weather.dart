import '../../../../core/utils/result.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

/// Parameters for [GetCurrentWeather].
class GetCurrentWeatherParams {
  final double latitude;
  final double longitude;

  const GetCurrentWeatherParams({
    required this.latitude,
    required this.longitude,
  });
}

/// Fetches the current weather at the given coordinates.
class GetCurrentWeather {
  final WeatherRepository repository;

  const GetCurrentWeather(this.repository);

  Future<Result<Weather>> call(GetCurrentWeatherParams params) {
    return repository.getCurrentWeather(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
