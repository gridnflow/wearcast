import 'package:flutter_test/flutter_test.dart';
import 'package:wearcast/features/outfit/domain/entities/clothing_item.dart';
import 'package:wearcast/features/outfit/domain/entities/outfit.dart';
import 'package:wearcast/features/outfit/domain/usecases/calculate_wear_score.dart';
import 'package:wearcast/features/outfit/domain/usecases/recommend_outfit.dart';

import '../../../../helpers/weather_fixtures.dart';

void main() {
  late RecommendOutfit recommender;

  setUp(() {
    recommender = const RecommendOutfit(
      scoreCalculator: CalculateWearScore(),
    );
  });

  group('category assignment', () {
    test('28°C+ returns extremeHot outfit (민소매/반팔)', () {
      final weather = buildWeather(temperature: 30, humidity: 100);
      final outfit = recommender(weather);
      expect(outfit.category, OutfitCategory.extremeHot);
      expect(outfit.category.label, '한여름');
      expect(
        outfit.items.any((i) => i.bodyPart == BodyPart.upper),
        isTrue,
      );
    });

    test('~4°C returns extremeCold outfit with heavy outer + accessory', () {
      final weather =
          buildWeather(temperature: 2, humidity: 100, windSpeed: 0);
      final outfit = recommender(weather);
      expect(outfit.category, OutfitCategory.extremeCold);
      expect(
        outfit.items.any((i) => i.bodyPart == BodyPart.outer),
        isTrue,
        reason: 'must include heavy outer (패딩/두꺼운코트)',
      );
      expect(
        outfit.items.any((i) => i.bodyPart == BodyPart.accessory),
        isTrue,
        reason: 'must include 목도리/장갑 accessory',
      );
    });

    test('18°C mid-range returns mild outfit with 가디건 outer', () {
      final weather = buildWeather(temperature: 18, humidity: 100);
      final outfit = recommender(weather);
      expect(outfit.category, OutfitCategory.mild);
      expect(
        outfit.items.any((i) => i.bodyPart == BodyPart.outer),
        isTrue,
      );
    });
  });

  group('weather modifiers', () {
    test('rain adds 우산 accessory and matching tip', () {
      final weather = buildWeather(
        temperature: 20,
        humidity: 100,
        condition: 'rain',
        precipitation: 3.0,
      );
      final outfit = recommender(weather);
      expect(
        outfit.items.any((i) => i.name.contains('우산')),
        isTrue,
      );
      expect(outfit.tip, contains('우산'));
    });

    test('strong wind (>5 m/s) adds 바람막이 outer', () {
      final weather = buildWeather(
        temperature: 22,
        humidity: 100,
        windSpeed: 8,
      );
      final outfit = recommender(weather);
      expect(
        outfit.items.any((i) => i.name.contains('바람막이')),
        isTrue,
      );
    });

    test('high humidity (>80%) produces a breathable-fabric tip', () {
      final weather = buildWeather(
        temperature: 25,
        humidity: 90,
      );
      final outfit = recommender(weather);
      expect(outfit.tip, contains('통기성'));
    });

    test('snow triggers heavy outer + warm accessory regardless of category',
        () {
      final weather = buildWeather(
        temperature: 7,
        humidity: 100,
        condition: 'snow',
        precipitation: 1.0,
      );
      final outfit = recommender(weather);
      expect(
        outfit.items.any((i) => i.bodyPart == BodyPart.accessory),
        isTrue,
      );
      expect(outfit.tip, contains('눈'));
    });
  });

  group('wearScore integration', () {
    test('outfit.wearScore is populated from the calculator', () {
      final weather = buildWeather(temperature: 18, humidity: 100);
      final outfit = recommender(weather);
      expect(outfit.wearScore, inInclusiveRange(0, 100));
      // Should be near-middle for mild weather.
      expect(outfit.wearScore, greaterThan(30));
      expect(outfit.wearScore, lessThan(70));
    });

    test('sensitivity propagates into both category and score', () {
      final weather =
          buildWeather(temperature: 20, humidity: 100, windSpeed: 0);
      final warm = recommender(weather, sensitivity: 3);
      final cold = recommender(weather, sensitivity: -3);
      expect(warm.category, OutfitCategory.hot);
      expect(cold.category, OutfitCategory.mild);
      expect(cold.wearScore, greaterThan(warm.wearScore));
    });
  });

  group('deterministic output', () {
    test('same input yields the same outfit', () {
      final weather = buildWeather(temperature: 15, humidity: 100);
      final a = recommender(weather);
      final b = recommender(weather);
      expect(a, equals(b));
    });
  });
}
