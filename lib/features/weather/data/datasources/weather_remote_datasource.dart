import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/dio_client.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<ForecastModel> getForecast({
    required double latitude,
    required double longitude,
  });
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio _dio;

  const WeatherRemoteDataSourceImpl(this._dio);

  @override
  Future<WeatherModel> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final l = L10n.current;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/weather',
        queryParameters: {'lat': latitude, 'lon': longitude},
      );
      final data = response.data;
      if (data == null) throw ServerException(l.errWeatherEmpty);
      return WeatherModel.fromCurrentJson(data);
    } on DioException catch (e) {
      throw ServerException(_mapDioError(e));
    } catch (e) {
      throw ServerException(l.errWeatherParse(e.toString()));
    }
  }

  @override
  Future<ForecastModel> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    final l = L10n.current;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/forecast',
        queryParameters: {'lat': latitude, 'lon': longitude},
      );
      final data = response.data;
      if (data == null) throw ServerException(l.errForecastEmpty);
      return ForecastModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(_mapDioError(e));
    } catch (e) {
      throw ServerException(l.errForecastParse(e.toString()));
    }
  }

  String _mapDioError(DioException e) {
    final l = L10n.current;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return l.errNetworkSlow;
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401) return l.errApiKey;
        if (status == 404) return l.errNotFound;
        if (status == 429) return l.errRateLimit;
        return l.errServerResponse(status?.toString() ?? '?');
      case DioExceptionType.connectionError:
        return l.errNoInternet;
      case DioExceptionType.cancel:
        return l.errRequestCancelled;
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return l.errUnknownNetwork;
    }
  }
}

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return WeatherRemoteDataSourceImpl(dio);
});
