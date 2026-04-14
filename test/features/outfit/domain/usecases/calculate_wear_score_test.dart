import 'package:flutter_test/flutter_test.dart';
import 'package:wearcast/features/outfit/domain/entities/outfit.dart';
import 'package:wearcast/features/outfit/domain/usecases/calculate_wear_score.dart';

import '../../../../helpers/weather_fixtures.dart';

void main() {
  late CalculateWearScore calculator;

  setUp(() {
    calculator = const CalculateWearScore();
  });

  group('apparentTemperature', () {
    test('returns raw temperature when humidity is 100% (no dryness offset)',
        () {
      // 100% 습도 → (1 - H/100) = 0 → 기온 보정 항 = 0
      final t = calculator.apparentTemperature(
        temperature: 25,
        humidity: 100,
        windSpeed: 0,
      );
      expect(t, closeTo(25.0, 0.001));
    });

    test('reduces apparent temperature when it is dry and warm', () {
      // formula: T - 0.55 * (1 - H/100) * (T - 14.5) - windChill
      // T=30, H=20, v=0 → 30 - 0.55 * 0.8 * 15.5 = 30 - 6.82 = 23.18
      final t = calculator.apparentTemperature(
        temperature: 30,
        humidity: 20,
        windSpeed: 0,
      );
      expect(t, closeTo(23.18, 0.01));
    });

    test('applies wind chill — stronger wind lowers apparent temperature', () {
      final calm = calculator.apparentTemperature(
        temperature: 5,
        humidity: 60,
        windSpeed: 0,
      );
      final windy = calculator.apparentTemperature(
        temperature: 5,
        humidity: 60,
        windSpeed: 10,
      );
      expect(windy, lessThan(calm));
    });

    test('wind chill only applies at low temperatures (≤ 10°C)', () {
      // At high temperatures wind should not increase "cold" feel meaningfully.
      final calm = calculator.apparentTemperature(
        temperature: 30,
        humidity: 50,
        windSpeed: 0,
      );
      final windy = calculator.apparentTemperature(
        temperature: 30,
        humidity: 50,
        windSpeed: 10,
      );
      expect((calm - windy).abs(), lessThan(0.001));
    });
  });

  group('categorize — temperature tiers', () {
    test('28°C and above → extremeHot', () {
      expect(calculator.categorize(28), OutfitCategory.extremeHot);
      expect(calculator.categorize(35), OutfitCategory.extremeHot);
    });

    test('23~27°C → hot', () {
      expect(calculator.categorize(23), OutfitCategory.hot);
      expect(calculator.categorize(27), OutfitCategory.hot);
    });

    test('20~22°C → warm', () {
      expect(calculator.categorize(20), OutfitCategory.warm);
      expect(calculator.categorize(22), OutfitCategory.warm);
    });

    test('17~19°C → mild', () {
      expect(calculator.categorize(17), OutfitCategory.mild);
      expect(calculator.categorize(19), OutfitCategory.mild);
    });

    test('12~16°C → cool', () {
      expect(calculator.categorize(12), OutfitCategory.cool);
      expect(calculator.categorize(16), OutfitCategory.cool);
    });

    test('9~11°C → chilly', () {
      expect(calculator.categorize(9), OutfitCategory.chilly);
      expect(calculator.categorize(11), OutfitCategory.chilly);
    });

    test('5~8°C → cold', () {
      expect(calculator.categorize(5), OutfitCategory.cold);
      expect(calculator.categorize(8), OutfitCategory.cold);
    });

    test('below 5°C → extremeCold', () {
      expect(calculator.categorize(4), OutfitCategory.extremeCold);
      expect(calculator.categorize(-10), OutfitCategory.extremeCold);
    });
  });

  group('wearScore (0-100)', () {
    test('extreme hot → near 0 (dress light)', () {
      final weather = buildWeather(temperature: 32, humidity: 60);
      final score = calculator.call(weather);
      expect(score, lessThanOrEqualTo(15));
      expect(score, greaterThanOrEqualTo(0));
    });

    test('mild 18°C → around 50 (middle of range)', () {
      final weather = buildWeather(temperature: 18, humidity: 50);
      final score = calculator.call(weather);
      expect(score, inInclusiveRange(40, 65));
    });

    test('extreme cold → near 100 (dress heavy)', () {
      final weather =
          buildWeather(temperature: -5, humidity: 50, windSpeed: 5);
      final score = calculator.call(weather);
      expect(score, greaterThanOrEqualTo(85));
      expect(score, lessThanOrEqualTo(100));
    });

    test('score is clamped to [0, 100]', () {
      final veryHot = buildWeather(temperature: 50, humidity: 90);
      final veryCold = buildWeather(temperature: -30, humidity: 50, windSpeed: 20);
      expect(calculator.call(veryHot), inInclusiveRange(0, 100));
      expect(calculator.call(veryCold), inInclusiveRange(0, 100));
    });

    test('windy cold day scores higher than calm cold day', () {
      final calm = buildWeather(temperature: 5, humidity: 50, windSpeed: 0);
      final windy = buildWeather(temperature: 5, humidity: 50, windSpeed: 12);
      expect(calculator.call(windy), greaterThan(calculator.call(calm)));
    });
  });

  group('sensitivity offset', () {
    test('positive sensitivity (+3) dresses user lighter → lower score', () {
      final weather = buildWeather(temperature: 15, humidity: 50);
      final normal = calculator.call(weather);
      final warmBlooded = calculator.call(weather, sensitivity: 3);
      expect(warmBlooded, lessThan(normal));
    });

    test('negative sensitivity (-3) dresses user heavier → higher score', () {
      final weather = buildWeather(temperature: 15, humidity: 50);
      final normal = calculator.call(weather);
      final coldBlooded = calculator.call(weather, sensitivity: -3);
      expect(coldBlooded, greaterThan(normal));
    });

    test('sensitivity shifts the outfit category at tier boundaries', () {
      // At H=100 the humidity correction vanishes so apparent == 20°C.
      // sensitivity +3 → "feels like" 23 → hot tier.
      final weather =
          buildWeather(temperature: 20, humidity: 100, windSpeed: 0);
      expect(
        calculator.categorizeForUser(weather, sensitivity: 3),
        OutfitCategory.hot,
      );
      // sensitivity -3 → "feels like" 17 → mild tier.
      expect(
        calculator.categorizeForUser(weather, sensitivity: -3),
        OutfitCategory.mild,
      );
    });
  });
}
