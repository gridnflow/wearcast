import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wearcast/core/error/failures.dart';
import 'package:wearcast/core/utils/result.dart';
import 'package:wearcast/features/outfit/domain/entities/clothing_item.dart';
import 'package:wearcast/features/outfit/domain/entities/outfit.dart';
import 'package:wearcast/features/outfit/domain/repositories/outfit_repository.dart';
import 'package:wearcast/features/outfit/domain/usecases/get_outfit_recommendation.dart';
import 'package:wearcast/features/weather/domain/entities/weather.dart';

import '../../../../helpers/weather_fixtures.dart';

class _MockOutfitRepository extends Mock implements OutfitRepository {}

class _FakeWeather extends Fake implements Weather {}

void main() {
  late _MockOutfitRepository repository;
  late GetOutfitRecommendation useCase;

  setUpAll(() {
    registerFallbackValue(_FakeWeather());
  });

  setUp(() {
    repository = _MockOutfitRepository();
    useCase = GetOutfitRecommendation(repository);
  });

  test('forwards weather + sensitivity to the repository', () async {
    final weather = buildWeather(temperature: 15);
    final outfit = Outfit(
      category: OutfitCategory.cool,
      items: const [
        ClothingItem(name: '니트', bodyPart: BodyPart.upper),
      ],
      tip: 'nice',
      wearScore: 55,
    );
    when(() => repository.recommend(
          weather: any(named: 'weather'),
          sensitivity: any(named: 'sensitivity'),
        )).thenAnswer((_) async => Ok(outfit));

    final result = await useCase(GetOutfitRecommendationParams(
      weather: weather,
      sensitivity: 1.5,
    ));

    expect(result.valueOrNull, outfit);
    verify(() => repository.recommend(
          weather: weather,
          sensitivity: 1.5,
        )).called(1);
  });

  test('defaults sensitivity to 0.0 when not provided', () async {
    final weather = buildWeather();
    when(() => repository.recommend(
          weather: any(named: 'weather'),
          sensitivity: any(named: 'sensitivity'),
        )).thenAnswer((_) async => Ok(Outfit(
              category: OutfitCategory.mild,
              items: const [],
              tip: '',
              wearScore: 50,
            )));

    await useCase(GetOutfitRecommendationParams(weather: weather));

    verify(() => repository.recommend(
          weather: weather,
          sensitivity: 0.0,
        )).called(1);
  });

  test('propagates failures from the repository', () async {
    when(() => repository.recommend(
          weather: any(named: 'weather'),
          sensitivity: any(named: 'sensitivity'),
        )).thenAnswer((_) async =>
            Err<Outfit>(const CacheFailure('no rules')));

    final result = await useCase(
      GetOutfitRecommendationParams(weather: buildWeather()),
    );

    expect(result.isErr, isTrue);
    expect(result.failureOrNull, isA<CacheFailure>());
  });
}
