import 'package:flutter_test/flutter_test.dart';
import 'package:wearcast/features/weather/data/models/weather_model.dart';

void main() {
  group('WeatherModel.fromCurrentJson', () {
    test('parses a complete OpenWeatherMap /weather response', () {
      final json = {
        'weather': [
          {'main': 'Clouds', 'description': '흐림', 'icon': '04d'},
        ],
        'main': {
          'temp': 12.3,
          'feels_like': 10.1,
          'humidity': 75,
        },
        'wind': {'speed': 3.5},
        'rain': {'1h': 0.8},
        'name': 'Seoul',
        'dt': 1710000000,
      };

      final model = WeatherModel.fromCurrentJson(json);

      expect(model.temp, 12.3);
      expect(model.feelsLike, 10.1);
      expect(model.humidity, 75);
      expect(model.windSpeed, 3.5);
      expect(model.main, 'Clouds');
      expect(model.description, '흐림');
      expect(model.icon, '04d');
      expect(model.precipitation, 0.8);
      expect(model.cityName, 'Seoul');
      expect(model.dt, 1710000000);
    });

    test('uses sensible defaults for missing fields', () {
      final model = WeatherModel.fromCurrentJson({});

      expect(model.temp, 0.0);
      expect(model.feelsLike, 0.0);
      expect(model.humidity, 0);
      expect(model.windSpeed, 0.0);
      expect(model.main, '');
      expect(model.description, '');
      expect(model.icon, '');
      expect(model.precipitation, 0.0);
      expect(model.cityName, '');
      expect(model.dt, 0);
    });

    test('falls back to snow.1h when rain is absent', () {
      final json = {
        'weather': [
          {'main': 'Snow', 'description': '눈', 'icon': '13d'},
        ],
        'main': {'temp': -2.0, 'feels_like': -5.0, 'humidity': 80},
        'wind': {'speed': 1.2},
        'snow': {'1h': 1.5},
        'name': 'Seoul',
        'dt': 1710000000,
      };

      final model = WeatherModel.fromCurrentJson(json);

      expect(model.precipitation, 1.5);
    });

    test('coerces stringified numbers', () {
      final json = {
        'weather': [
          {'main': 'Clear', 'description': '맑음', 'icon': '01d'},
        ],
        'main': {'temp': '15.5', 'feels_like': '14.0', 'humidity': '60'},
        'wind': {'speed': '2.0'},
        'name': 'Busan',
        'dt': '1710000000',
      };

      final model = WeatherModel.fromCurrentJson(json);

      expect(model.temp, 15.5);
      expect(model.feelsLike, 14.0);
      expect(model.humidity, 60);
      expect(model.windSpeed, 2.0);
      expect(model.dt, 1710000000);
    });
  });

  group('WeatherModel.toEntity', () {
    test('maps fields and normalizes condition to lowercase', () {
      final model = WeatherModel.fromCurrentJson({
        'weather': [
          {'main': 'Rain', 'description': '비', 'icon': '10d'},
        ],
        'main': {'temp': 18.0, 'feels_like': 17.0, 'humidity': 90},
        'wind': {'speed': 4.0},
        'rain': {'1h': 2.3},
        'name': 'Seoul',
        'dt': 1710000000,
      });

      final weather = model.toEntity();

      expect(weather.condition, 'rain');
      expect(weather.description, '비');
      expect(weather.temperature, 18.0);
      expect(weather.feelsLike, 17.0);
      expect(weather.humidity, 90);
      expect(weather.windSpeed, 4.0);
      expect(weather.precipitation, 2.3);
      expect(weather.cityName, 'Seoul');
      expect(weather.dateTime.millisecondsSinceEpoch, 1710000000 * 1000);
    });
  });
}
