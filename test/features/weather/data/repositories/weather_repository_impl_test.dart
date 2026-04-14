import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearcast/core/error/exceptions.dart';
import 'package:wearcast/core/error/failures.dart';
import 'package:wearcast/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:wearcast/features/weather/data/models/weather_model.dart';
import 'package:wearcast/features/weather/data/repositories/weather_repository_impl.dart';

class _MockRemote extends Mock implements WeatherRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late WeatherRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = WeatherRepositoryImpl(remoteDataSource: remote);
  });

  final sampleModel = WeatherModel.fromCurrentJson({
    'weather': [
      {'main': 'Clear', 'description': '맑음', 'icon': '01d'},
    ],
    'main': {'temp': 20.0, 'feels_like': 19.0, 'humidity': 50},
    'wind': {'speed': 1.5},
    'name': 'Seoul',
    'dt': 1710000000,
  });

  group('getCurrentWeather', () {
    test('returns Ok with mapped entity on success', () async {
      when(() => remote.getCurrentWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenAnswer((_) async => sampleModel);

      final result = await repository.getCurrentWeather(
        latitude: 37.5665,
        longitude: 126.9780,
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.cityName, 'Seoul');
      expect(result.valueOrNull?.condition, 'clear');
    });

    test('maps ServerException to ServerFailure', () async {
      when(() => remote.getCurrentWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenThrow(const ServerException('서버 오류'));

      final result = await repository.getCurrentWeather(
        latitude: 0,
        longitude: 0,
      );

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
      expect(result.failureOrNull?.message, '서버 오류');
    });

    test('maps unknown exception to ServerFailure with generic message', () async {
      when(() => remote.getCurrentWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenThrow(Exception('boom'));

      final result = await repository.getCurrentWeather(
        latitude: 0,
        longitude: 0,
      );

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
