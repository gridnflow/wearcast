import 'package:flutter/foundation.dart';

import 'clothing_item.dart';

/// Broad temperature-based outfit category.
///
/// Roughly maps to the 8 Korean seasonal tiers used in the recommendation
/// engine (한여름, 여름, 초가을, 가을, 늦가을, 초겨울, 겨울, 한겨울).
enum OutfitCategory {
  extremeHot, // 28°C+
  hot, // 23 ~ 27°C
  warm, // 20 ~ 22°C
  mild, // 17 ~ 19°C
  cool, // 12 ~ 16°C
  chilly, // 9 ~ 11°C
  cold, // 5 ~ 8°C
  extremeCold, // ~4°C
}

/// Human-readable label for a [OutfitCategory].
extension OutfitCategoryLabel on OutfitCategory {
  String get label {
    switch (this) {
      case OutfitCategory.extremeHot:
        return '한여름';
      case OutfitCategory.hot:
        return '여름';
      case OutfitCategory.warm:
        return '초가을';
      case OutfitCategory.mild:
        return '가을';
      case OutfitCategory.cool:
        return '늦가을';
      case OutfitCategory.chilly:
        return '초겨울';
      case OutfitCategory.cold:
        return '겨울';
      case OutfitCategory.extremeCold:
        return '한겨울';
    }
  }
}

/// An outfit recommendation.
///
/// [wearScore] is an integer 0–100 summarising how warmly the user should
/// dress (0 = very light, 100 = very heavy). [tip] holds a freeform,
/// context-sensitive hint (e.g. "우산을 챙기세요!").
@immutable
class Outfit {
  final OutfitCategory category;
  final List<ClothingItem> items;
  final String tip;
  final int wearScore;

  const Outfit({
    required this.category,
    required this.items,
    required this.tip,
    required this.wearScore,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Outfit &&
        other.category == category &&
        listEquals(other.items, items) &&
        other.tip == tip &&
        other.wearScore == wearScore;
  }

  @override
  int get hashCode =>
      Object.hash(category, Object.hashAll(items), tip, wearScore);

  @override
  String toString() =>
      'Outfit(${category.label}, score: $wearScore, items: ${items.length})';
}
