import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get openWeatherMapApiKey =>
      dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static const String openWeatherMapBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  static const Duration defaultTimeout = Duration(seconds: 30);
}
