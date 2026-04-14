import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearcast/core/error/failures.dart';
import 'package:wearcast/core/utils/result.dart';
import 'package:wearcast/features/weather/domain/entities/weather.dart';
import 'package:wearcast/features/weather/domain/repositories/weather_repository.dart';
import 'package:wearcast/features/weather/domain/usecases/get_current_weather.dart';

import '../../../../helpers/weather_fixtures.dart';

class _MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late _MockWeatherRepository repository;
  late GetCurrentWeather useCase;

  setUp(() {
    repository = _MockWeatherRepository();
    useCase = GetCurrentWeather(repository);
  });

  final params = const GetCurrentWeatherParams(
    latitude: 37.5665,
    longitude: 126.978,
  );

  test('returns Ok(Weather) when repository succeeds', () async {
    final weather = buildWeather();
    when(() => repository.getCurrentWeather(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async => Ok(weather));

    final result = await useCase(params);

    expect(result, isA<Ok<Weather>>());
    expect(result.valueOrNull, weather);
    verify(() => repository.getCurrentWeather(
          latitude: 37.5665,
          longitude: 126.978,
        )).called(1);
  });

  test('returns Err(Failure) when repository fails', () async {
    when(() => repository.getCurrentWeather(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async =>
            Err<Weather>(const ServerFailure('boom')));

    final result = await useCase(params);

    expect(result.isErr, isTrue);
    expect(result.failureOrNull, isA<ServerFailure>());
  });

  test('forwards coordinates verbatim to the repository', () async {
    when(() => repository.getCurrentWeather(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        )).thenAnswer((_) async => Ok(buildWeather()));

    await useCase(const GetCurrentWeatherParams(
      latitude: -33.87,
      longitude: 151.21,
    ));

    verify(() => repository.getCurrentWeather(
          latitude: -33.87,
          longitude: 151.21,
        )).called(1);
  });
}
