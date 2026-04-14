import 'package:wearcast/features/weather/domain/entities/weather.dart';

/// Builds a [Weather] fixture with safe defaults, allowing tests to override
/// only the fields that matter for the scenario.
Weather buildWeather({
  double temperature = 20.0,
  double? feelsLike,
  int humidity = 50,
  double windSpeed = 1.0,
  String condition = 'clear',
  String description = '맑음',
  String icon = '01d',
  double precipitation = 0.0,
  String cityName = 'Seoul',
  DateTime? dateTime,
}) {
  return Weather(
    temperature: temperature,
    feelsLike: feelsLike ?? temperature,
    humidity: humidity,
    windSpeed: windSpeed,
    condition: condition,
    description: description,
    icon: icon,
    precipitation: precipitation,
    cityName: cityName,
    dateTime: dateTime ?? DateTime(2026, 4, 14, 9),
  );
}
