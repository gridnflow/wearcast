import 'package:flutter/foundation.dart';

/// Body part / slot a clothing item occupies.
enum BodyPart { upper, lower, outer, shoes, accessory }

/// A single recommended clothing item.
@immutable
class ClothingItem {
  final String name;
  final BodyPart bodyPart;
  final String iconAsset;

  const ClothingItem({
    required this.name,
    required this.bodyPart,
    this.iconAsset = '',
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClothingItem &&
        other.name == name &&
        other.bodyPart == bodyPart &&
        other.iconAsset == iconAsset;
  }

  @override
  int get hashCode => Object.hash(name, bodyPart, iconAsset);

  @override
  String toString() => 'ClothingItem($name, $bodyPart)';
}
