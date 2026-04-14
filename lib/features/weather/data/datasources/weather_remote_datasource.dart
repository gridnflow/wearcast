import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

/// Contract for fetching weather data from a remote source (OpenWeatherMap).
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

/// OpenWeatherMap implementation of [WeatherRemoteDataSource].
///
/// Endpoints:
/// - `GET /weather?lat=..&lon=..` -> current weather
/// - `GET /forecast?lat=..&lon=..` -> 5-day / 3-hour forecast
///
/// Authentication, base URL, and default query params (`units`, `lang`) are
/// injected by [dioClientProvider].
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio _dio;

  const WeatherRemoteDataSourceImpl(this._dio);

  @override
  Future<WeatherModel> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/weather',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('현재 날씨 응답이 비어있습니다.');
      }

      return WeatherModel.fromCurrentJson(data);
    } on DioException catch (e) {
      throw ServerException(_mapDioError(e));
    } catch (e) {
      throw ServerException('현재 날씨 파싱 실패: $e');
    }
  }

  @override
  Future<ForecastModel> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/forecast',
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
        },
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException('예보 응답이 비어있습니다.');
      }

      return ForecastModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(_mapDioError(e));
    } catch (e) {
      throw ServerException('예보 파싱 실패: $e');
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return '네트워크 연결이 지연되고 있습니다.';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401) {
          return 'API 키가 유효하지 않습니다. (401)';
        }
        if (status == 404) {
          return '요청한 위치의 날씨 정보를 찾을 수 없습니다. (404)';
        }
        if (status == 429) {
          return 'API 호출 한도를 초과했습니다. 잠시 후 다시 시도해 주세요. (429)';
        }
        return '날씨 서버 응답 오류 (${status ?? '?'}).';
      case DioExceptionType.connectionError:
        return '인터넷 연결을 확인해 주세요.';
      case DioExceptionType.cancel:
        return '요청이 취소되었습니다.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return '알 수 없는 네트워크 오류가 발생했습니다.';
    }
  }
}

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider);
  return WeatherRemoteDataSourceImpl(dio);
});
