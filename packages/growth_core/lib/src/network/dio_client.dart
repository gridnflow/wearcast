import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Builds a configured [Dio] instance with sane timeouts and debug-only
/// logging. Generalised from wearcast's `dioClientProvider` so each app just
/// passes its base url / default query params instead of re-writing the setup.
Dio buildDioClient({
  required String baseUrl,
  Duration timeout = const Duration(seconds: 15),
  Map<String, dynamic> defaultQueryParameters = const {},
  Map<String, dynamic> headers = const {'Accept': 'application/json'},
  List<Interceptor> interceptors = const [],
  bool logInDebug = true,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      queryParameters: defaultQueryParameters,
      headers: headers,
    ),
  );

  dio.interceptors.addAll(interceptors);

  if (logInDebug && kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => debugPrint('[Dio] $obj'),
      ),
    );
  }

  return dio;
}
