import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  const WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final model = await remoteDataSource.getCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );
      return Ok(model.toEntity());
    } on ServerException catch (e) {
      return Err(ServerFailure(e.message));
    } on DioException catch (e) {
      return Err(NetworkFailure(e.message ?? L10n.current.errNetworkFailed));
    } catch (e, st) {
      if (kDebugMode) debugPrint('[WeatherRepository] unexpected: $e\n$st');
      return Err(ServerFailure(L10n.current.errCurrentWeather));
    }
  }

  @override
  Future<Result<Forecast>> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final model = await remoteDataSource.getForecast(
        latitude: latitude,
        longitude: longitude,
      );
      return Ok(model.toEntity());
    } on ServerException catch (e) {
      return Err(ServerFailure(e.message));
    } on DioException catch (e) {
      return Err(NetworkFailure(e.message ?? L10n.current.errNetworkFailed));
    } catch (e, st) {
      if (kDebugMode) debugPrint('[WeatherRepository] unexpected: $e\n$st');
      return Err(ServerFailure(L10n.current.errForecast));
    }
  }
}

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final remote = ref.watch(weatherRemoteDataSourceProvider);
  return WeatherRepositoryImpl(remoteDataSource: remote);
});
