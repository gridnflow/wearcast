import 'package:flutter/foundation.dart';

/// A geographic coordinate pair.
///
/// Used as the input argument to weather providers. Equality is structural so
/// Riverpod's `family` can cache by value.
@immutable
class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates({
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Coordinates &&
          other.latitude == latitude &&
          other.longitude == longitude);

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'Coordinates($latitude, $longitude)';
}
