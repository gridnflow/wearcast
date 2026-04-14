import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';

/// Provides a configured [Dio] instance targeting OpenWeatherMap.
///
/// - Injects `appid`, `units=metric`, `lang=kr` into every request.
/// - Logs request/response bodies in debug builds only.
final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.openWeatherMapBaseUrl,
      connectTimeout: ApiConstants.defaultTimeout,
      receiveTimeout: ApiConstants.defaultTimeout,
      queryParameters: {
        'appid': ApiConstants.openWeatherMapApiKey,
        'units': 'metric',
        'lang': 'kr',
      },
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        request: true,
        logPrint: (obj) => debugPrint('[Dio] $obj'),
      ),
    );
  }

  return dio;
});
