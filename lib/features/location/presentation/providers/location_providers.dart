import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/geolocator_location_service.dart';
import '../../domain/entities/coordinates.dart';
import '../../domain/location_service.dart';

/// DI for the [LocationService]. Override in tests / dev via
/// `locationServiceProvider.overrideWithValue(...)`.
final locationServiceProvider = Provider<LocationService>((ref) {
  return GeolocatorLocationService();
});

/// Async state: the device's current coordinates.
///
/// Kept as a one-shot [FutureProvider] (not a stream) because the weather
/// lookup only needs a single position per refresh. Invalidate to retry:
/// `ref.invalidate(currentCoordinatesProvider)`.
final currentCoordinatesProvider = FutureProvider<Coordinates>((ref) async {
  final service = ref.watch(locationServiceProvider);
  return service.getCurrentCoordinates();
});
