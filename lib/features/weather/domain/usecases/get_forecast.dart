import '../../../../core/utils/result.dart';
import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

/// Parameters for [GetForecast].
class GetForecastParams {
  final double latitude;
  final double longitude;

  const GetForecastParams({
    required this.latitude,
    required this.longitude,
  });
}

/// Fetches a multi-day forecast at the given coordinates.
class GetForecast {
  final WeatherRepository repository;

  const GetForecast(this.repository);

  Future<Result<Forecast>> call(GetForecastParams params) {
    return repository.getForecast(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
