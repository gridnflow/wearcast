import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_core/growth_core.dart';

import '../constants/api_constants.dart';

/// Provides a configured [Dio] instance targeting OpenWeatherMap.
///
/// The generic setup (timeouts, debug logging) comes from growth_core's
/// [buildDioClient]; only the OpenWeatherMap-specific base url and default
/// query params live here.
final dioClientProvider = Provider<Dio>((ref) {
  return buildDioClient(
    baseUrl: ApiConstants.openWeatherMapBaseUrl,
    timeout: ApiConstants.defaultTimeout,
    defaultQueryParameters: {
      'appid': ApiConstants.openWeatherMapApiKey,
      'units': 'metric',
      'lang': 'kr',
    },
  );
});
