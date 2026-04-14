import 'package:flutter_test/flutter_test.dart';
import 'package:wearcast/features/weather/data/models/forecast_model.dart';

void main() {
  group('ForecastModel.fromJson', () {
    test('parses city name and list entries', () {
      final json = {
        'city': {'name': 'Seoul'},
        'list': [
          {
            'dt': 1710000000,
            'main': {'temp': 10.0, 'feels_like': 8.0, 'humidity': 60},
            'wind': {'speed': 2.0},
            'weather': [
              {'main': 'Clear', 'description': '맑음', 'icon': '01d'},
            ],
          },
          {
            'dt': 1710010800,
            'main': {'temp': 12.0, 'feels_like': 11.0, 'humidity': 55},
            'wind': {'speed': 2.5},
            'weather': [
              {'main': 'Clouds', 'description': '구름', 'icon': '02d'},
            ],
          },
        ],
      };

      final model = ForecastModel.fromJson(json);

      expect(model.cityName, 'Seoul');
      expect(model.entries.length, 2);
      expect(model.entries.first.temp, 10.0);
      expect(model.entries.last.temp, 12.0);
    });

    test('handles missing list gracefully', () {
      final model = ForecastModel.fromJson({'city': {'name': 'Seoul'}});

      expect(model.cityName, 'Seoul');
      expect(model.entries, isEmpty);
    });
  });

  group('ForecastModel.toEntity', () {
    test('produces hourly entries and one daily entry per calendar day', () {
      // Two days, 3 slots each. Pick hours near noon to ensure noon-preference
      // doesn't accidentally pick something else.
      final day1Noon = DateTime(2026, 4, 13, 12, 0).toUtc();
      final day1Morning = DateTime(2026, 4, 13, 6, 0).toUtc();
      final day1Evening = DateTime(2026, 4, 13, 18, 0).toUtc();
      final day2Noon = DateTime(2026, 4, 14, 12, 0).toUtc();
      final day2Morning = DateTime(2026, 4, 14, 6, 0).toUtc();

      final json = {
        'city': {'name': 'Seoul'},
        'list': [
          _entry(day1Morning, 8),
          _entry(day1Noon, 15),
          _entry(day1Evening, 10),
          _entry(day2Morning, 9),
          _entry(day2Noon, 16),
        ],
      };

      final forecast = ForecastModel.fromJson(json).toEntity();

      expect(forecast.cityName, 'Seoul');
      expect(forecast.hourly.length, 5);
      expect(forecast.daily.length, 2);
      // Daily entries should be sorted chronologically.
      expect(
        forecast.daily.first.dateTime.isBefore(forecast.daily.last.dateTime),
        isTrue,
      );
    });
  });
}

Map<String, dynamic> _entry(DateTime utc, double temp) => {
      'dt': utc.millisecondsSinceEpoch ~/ 1000,
      'main': {'temp': temp, 'feels_like': temp - 1, 'humidity': 60},
      'wind': {'speed': 2.0},
      'weather': [
        {'main': 'Clear', 'description': '맑음', 'icon': '01d'},
      ],
    };
