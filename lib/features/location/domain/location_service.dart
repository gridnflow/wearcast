import 'entities/coordinates.dart';

/// Contract for acquiring the user's current geographic position.
///
/// Split from the Geolocator-based implementation so presentation-layer code
/// can be tested without touching platform channels.
abstract class LocationService {
  /// Returns the device's current coordinates.
  ///
  /// Throws a [LocationServiceException] when location services are disabled
  /// or permissions are denied.
  Future<Coordinates> getCurrentCoordinates();
}

/// Errors produced by [LocationService]. Mirrors Geolocator's permission
/// states so the UI can route to platform settings when appropriate.
class LocationServiceException implements Exception {
  final String message;
  final LocationErrorKind kind;

  const LocationServiceException(this.message, this.kind);

  @override
  String toString() => 'LocationServiceException($kind): $message';
}

enum LocationErrorKind {
  /// Device-level location services (GPS) are turned off.
  serviceDisabled,

  /// The user denied this app's location permission this session.
  permissionDenied,

  /// The user has permanently denied the permission; only resolvable via
  /// system settings.
  permissionDeniedForever,

  /// Unexpected failure (timeout, hardware error, etc.).
  unknown,
}
