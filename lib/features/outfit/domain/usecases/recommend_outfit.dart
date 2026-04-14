import '../../../weather/domain/entities/weather.dart';
import '../entities/clothing_item.dart';
import '../entities/outfit.dart';
import 'calculate_wear_score.dart';

/// Pure rule engine that maps [Weather] + user [sensitivity] to an [Outfit].
///
/// Design notes:
///   * This use case is deliberately synchronous and side-effect free.
///     The async [OutfitRepository.recommend] wrapper in the data layer
///     simply delegates to it.
///   * The category lookup table lives in [_baseItemsFor] to keep the
///     mapping dense and easy to scan during review.
///   * Modifiers (rain/wind/snow/humidity) are layered on top of the
///     base outfit rather than baked into the table — each is independent
///     and additive.
class RecommendOutfit {
  final CalculateWearScore scoreCalculator;

  const RecommendOutfit({required this.scoreCalculator});

  /// Recommend an outfit for [weather] given the user's [sensitivity] offset
  /// in °C (see [CalculateWearScore.call]).
  Outfit call(Weather weather, {double sensitivity = 0.0}) {
    final category = scoreCalculator.categorizeForUser(
      weather,
      sensitivity: sensitivity,
    );
    final score = scoreCalculator.call(weather, sensitivity: sensitivity);

    final items = [..._baseItemsFor(category)];
    final tipParts = <String>[];

    // --- Modifier: precipitation / condition ---
    final condition = weather.condition.toLowerCase();
    final rainy = condition.contains('rain') || weather.precipitation > 0.1;
    final snowy = condition.contains('snow');

    if (rainy && !snowy) {
      items.add(const ClothingItem(
        name: '우산',
        bodyPart: BodyPart.accessory,
        iconAsset: 'assets/icons/umbrella.svg',
      ));
      tipParts.add('우산을 챙기세요!');
    }

    if (snowy) {
      // Snow always warrants warm head/hand accessories + waterproof shoes.
      if (!items.any((i) => i.bodyPart == BodyPart.accessory)) {
        items.add(const ClothingItem(
          name: '목도리',
          bodyPart: BodyPart.accessory,
          iconAsset: 'assets/icons/scarf.svg',
        ));
      }
      items.add(const ClothingItem(
        name: '방수 부츠',
        bodyPart: BodyPart.shoes,
        iconAsset: 'assets/icons/boots.svg',
      ));
      tipParts.add('눈이 와요. 미끄럼 주의!');
    }

    // --- Modifier: wind ---
    if (weather.windSpeed > 5.0 &&
        !items.any((i) => i.name.contains('패딩') || i.name.contains('코트'))) {
      items.add(const ClothingItem(
        name: '바람막이',
        bodyPart: BodyPart.outer,
        iconAsset: 'assets/icons/windbreaker.svg',
      ));
      tipParts.add('바람이 강해요.');
    }

    // --- Modifier: humidity ---
    if (weather.humidity > 80 && category.index <= OutfitCategory.warm.index) {
      // Only meaningful in warm weather — a muggy winter day doesn't need
      // "breathable fabric" advice.
      tipParts.add('습도가 높아요. 통기성 좋은 소재를 추천해요.');
    }

    return Outfit(
      category: category,
      items: List.unmodifiable(items),
      tip: tipParts.isEmpty ? _defaultTipFor(category) : tipParts.join(' '),
      wearScore: score,
    );
  }

  // --- Lookup tables ---------------------------------------------------------

  List<ClothingItem> _baseItemsFor(OutfitCategory c) {
    switch (c) {
      case OutfitCategory.extremeHot:
        return const [
          ClothingItem(name: '민소매/반팔', bodyPart: BodyPart.upper),
          ClothingItem(name: '반바지/치마', bodyPart: BodyPart.lower),
          ClothingItem(name: '샌들', bodyPart: BodyPart.shoes),
        ];
      case OutfitCategory.hot:
        return const [
          ClothingItem(name: '반팔/린넨셔츠', bodyPart: BodyPart.upper),
          ClothingItem(name: '면바지/반바지', bodyPart: BodyPart.lower),
          ClothingItem(name: '스니커즈', bodyPart: BodyPart.shoes),
        ];
      case OutfitCategory.warm:
        return const [
          ClothingItem(name: '긴팔/얇은 셔츠', bodyPart: BodyPart.upper),
          ClothingItem(name: '청바지/면바지', bodyPart: BodyPart.lower),
          ClothingItem(name: '얇은 가디건', bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.mild:
        return const [
          ClothingItem(name: '맨투맨/니트', bodyPart: BodyPart.upper),
          ClothingItem(name: '청바지/면바지', bodyPart: BodyPart.lower),
          ClothingItem(name: '가디건', bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.cool:
        return const [
          ClothingItem(name: '니트/셔츠', bodyPart: BodyPart.upper),
          ClothingItem(name: '청바지', bodyPart: BodyPart.lower),
          ClothingItem(name: '자켓/야상', bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.chilly:
        return const [
          ClothingItem(name: '기모 맨투맨', bodyPart: BodyPart.upper),
          ClothingItem(name: '기모 바지', bodyPart: BodyPart.lower),
          ClothingItem(name: '트렌치코트', bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.cold:
        return const [
          ClothingItem(name: '히트텍 + 니트', bodyPart: BodyPart.upper),
          ClothingItem(name: '기모 바지', bodyPart: BodyPart.lower),
          ClothingItem(name: '코트', bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.extremeCold:
        return const [
          ClothingItem(name: '히트텍 + 두꺼운 니트', bodyPart: BodyPart.upper),
          ClothingItem(name: '기모 바지', bodyPart: BodyPart.lower),
          ClothingItem(name: '패딩/두꺼운 코트', bodyPart: BodyPart.outer),
          ClothingItem(name: '목도리 + 장갑', bodyPart: BodyPart.accessory),
        ];
    }
  }

  String _defaultTipFor(OutfitCategory c) {
    switch (c) {
      case OutfitCategory.extremeHot:
        return '수분 보충 잊지 마세요!';
      case OutfitCategory.hot:
        return '시원하게 입고 나가세요.';
      case OutfitCategory.warm:
        return '쌀쌀할 수 있으니 얇은 겉옷 챙기세요.';
      case OutfitCategory.mild:
        return '가볍게 걸칠 겉옷이 있으면 좋아요.';
      case OutfitCategory.cool:
        return '자켓 하나 걸치세요.';
      case OutfitCategory.chilly:
        return '따뜻하게 입고 나가세요.';
      case OutfitCategory.cold:
        return '두툼한 코트가 필요한 날씨예요.';
      case OutfitCategory.extremeCold:
        return '보온에 신경 쓰세요. 외출 시 목도리·장갑 필수!';
    }
  }
}
