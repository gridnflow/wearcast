import '../../../../core/l10n/l10n.dart';
import '../../../weather/domain/entities/weather.dart';
import '../entities/clothing_item.dart';
import '../entities/outfit.dart';
import 'calculate_wear_score.dart';

class RecommendOutfit {
  final CalculateWearScore scoreCalculator;

  const RecommendOutfit({required this.scoreCalculator});

  Outfit call(Weather weather, {double sensitivity = 0.0}) {
    final l = L10n.current;
    final category = scoreCalculator.categorizeForUser(
      weather,
      sensitivity: sensitivity,
    );
    final score = scoreCalculator.call(weather, sensitivity: sensitivity);

    final items = [..._baseItemsFor(category, l)];
    final tipParts = <String>[];

    final condition = weather.condition.toLowerCase();
    final rainy = condition.contains('rain') || weather.precipitation > 0.1;
    final snowy = condition.contains('snow');

    if (rainy && !snowy) {
      items.add(ClothingItem(
        name: l.itemUmbrella,
        bodyPart: BodyPart.accessory,
        iconAsset: 'assets/icons/umbrella.svg',
      ));
      tipParts.add(l.tipUmbrella);
    }

    if (snowy) {
      if (!items.any((i) => i.bodyPart == BodyPart.accessory)) {
        items.add(ClothingItem(
          name: l.itemScarf,
          bodyPart: BodyPart.accessory,
          iconAsset: 'assets/icons/scarf.svg',
        ));
      }
      items.add(ClothingItem(
        name: l.itemWaterproofBoots,
        bodyPart: BodyPart.shoes,
        iconAsset: 'assets/icons/boots.svg',
      ));
      tipParts.add(l.tipSnow);
    }

    // Add windbreaker only for categories without heavy outerwear
    if (weather.windSpeed > 5.0 && category.index < OutfitCategory.cold.index) {
      items.add(ClothingItem(
        name: l.itemWindbreaker,
        bodyPart: BodyPart.outer,
        iconAsset: 'assets/icons/windbreaker.svg',
      ));
      tipParts.add(l.tipWind);
    }

    if (weather.humidity > 80 && category.index <= OutfitCategory.warm.index) {
      tipParts.add(l.tipHumidity);
    }

    return Outfit(
      category: category,
      items: List.unmodifiable(items),
      tip: tipParts.isEmpty ? _defaultTipFor(category, l) : tipParts.join(' '),
      wearScore: score,
    );
  }

  List<ClothingItem> _baseItemsFor(OutfitCategory c, dynamic l) {
    switch (c) {
      case OutfitCategory.extremeHot:
        return [
          ClothingItem(name: l.itemSleeveless, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemShorts, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemSandals, bodyPart: BodyPart.shoes),
        ];
      case OutfitCategory.hot:
        return [
          ClothingItem(name: l.itemTshirt, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemCottonPants, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemSneakers, bodyPart: BodyPart.shoes),
        ];
      case OutfitCategory.warm:
        return [
          ClothingItem(name: l.itemLongSleeve, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemJeans, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemLightCardigan, bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.mild:
        return [
          ClothingItem(name: l.itemSweatshirt, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemJeans, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemCardigan, bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.cool:
        return [
          ClothingItem(name: l.itemKnit, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemJeansOnly, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemJacket, bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.chilly:
        return [
          ClothingItem(name: l.itemFleeceSweatshirt, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemFleecePants, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemTrenchcoat, bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.cold:
        return [
          ClothingItem(name: l.itemHeattech, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemFleecePants, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemCoat, bodyPart: BodyPart.outer),
        ];
      case OutfitCategory.extremeCold:
        return [
          ClothingItem(name: l.itemHeavyHeattech, bodyPart: BodyPart.upper),
          ClothingItem(name: l.itemFleecePants, bodyPart: BodyPart.lower),
          ClothingItem(name: l.itemPadding, bodyPart: BodyPart.outer),
          ClothingItem(name: l.itemScarfGloves, bodyPart: BodyPart.accessory),
        ];
    }
  }

  String _defaultTipFor(OutfitCategory c, dynamic l) {
    switch (c) {
      case OutfitCategory.extremeHot:  return l.tipExtremeHot;
      case OutfitCategory.hot:         return l.tipHot;
      case OutfitCategory.warm:        return l.tipWarm;
      case OutfitCategory.mild:        return l.tipMild;
      case OutfitCategory.cool:        return l.tipCool;
      case OutfitCategory.chilly:      return l.tipChilly;
      case OutfitCategory.cold:        return l.tipCold;
      case OutfitCategory.extremeCold: return l.tipExtremeCold;
    }
  }
}
