import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearcast/core/error/failures.dart';
import 'package:wearcast/core/utils/result.dart';
import 'package:wearcast/features/weather/domain/entities/forecast.dart';
import 'package:wearcast/features/weather/domain/repositories/weather_repository.dart';
import 'package:wearcast/features/weather/domain/usecases/get_forecast.dart';

class _MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late _MockWeatherRepository repository;
  late GetForecast useCase;

  setUp(() {
    repository = _MockWeatherRepository();
    useCase = GetForecast(repository);
  });

  const params = GetForecastParams(
    latitude: 37.5665,
    longitude: 126.978,
  );

  test('delegates to repository.getForecast and returns its result', () async {
    final forecast = Forecast(
      cityName: 'Seoul',
      hourly: const [],
      daily: [
        ForecastEntry(
          dateTime: DateTime(2026, 4, 14),
          temperature: 18,
          feelsLike: 17,
          humidity: 55,
          windSpeed: 2,
          precipitation: 0,
          condition: 'clear',
          description: '맑음',
          icon: '01d',
        ),
      ],
    );
    when(() => repository.getForecast(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async => Ok(forecast));

    final result = await useCase(params);

    expect(result.valueOrNull, forecast);
    verify(() => repository.getForecast(
          latitude: 37.5665,
          longitude: 126.978,
        )).called(1);
  });

  test('propagates failures', () async {
    when(() => repository.getForecast(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async =>
            Err<Forecast>(const NetworkFailure('offline')));

    final result = await useCase(params);

    expect(result.isErr, isTrue);
    expect(result.failureOrNull, isA<NetworkFailure>());
  });
}
