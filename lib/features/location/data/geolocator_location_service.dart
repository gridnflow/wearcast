import 'package:geolocator/geolocator.dart';

import '../../../../core/l10n/l10n.dart';
import '../domain/entities/coordinates.dart';
import '../domain/location_service.dart';

class GeolocatorLocationService implements LocationService {
  final Future<bool> Function() _isServiceEnabled;
  final Future<LocationPermission> Function() _checkPermission;
  final Future<LocationPermission> Function() _requestPermission;
  final Future<Position> Function() _getCurrentPosition;

  GeolocatorLocationService({
    Future<bool> Function()? isServiceEnabled,
    Future<LocationPermission> Function()? checkPermission,
    Future<LocationPermission> Function()? requestPermission,
    Future<Position> Function()? getCurrentPosition,
  })  : _isServiceEnabled =
            isServiceEnabled ?? Geolocator.isLocationServiceEnabled,
        _checkPermission = checkPermission ?? Geolocator.checkPermission,
        _requestPermission = requestPermission ?? Geolocator.requestPermission,
        _getCurrentPosition = getCurrentPosition ?? _defaultGetCurrentPosition;

  /// Fetches a position with fallbacks so a slow or unavailable fix does not
  /// hard-fail the whole flow.
  ///
  /// City-level accuracy is all a weather app needs, so any cached or coarse
  /// fix is acceptable. The previous implementation asked for a fresh
  /// [LocationAccuracy.medium] fix with a 10s limit and only fell back to the
  /// last-known position; on a cold GNSS start (indoors) or an emulator without
  /// a network fix that reliably times out with no cached position to fall back
  /// on. Instead we try progressively cheaper/faster sources.
  static Future<Position> _defaultGetCurrentPosition() async {
    // A previously cached fix is good enough for weather and returns instantly,
    // so grab it up front to use as a fallback if a fresh fix is slow/absent.
    Position? lastKnown;
    try {
      lastKnown = await Geolocator.getLastKnownPosition();
    } catch (_) {
      lastKnown = null;
    }

    // Try a fresh fix. High accuracy drives the GPS/GNSS provider directly,
    // which cold-starts more reliably (and, on emulators, is the provider fed
    // by mock locations) than the fused/network provider used by medium.
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );
    } catch (_) {
      // Fresh fix failed (usually a timeout). Prefer any cached position over
      // failing outright.
      if (lastKnown != null) return lastKnown;

      // Last resort: a coarse, best-effort fix with no time limit. Lowest
      // accuracy resolves fastest and lets a network-only device still report
      // an approximate location.
      return Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.lowest,
        ),
      );
    }
  }

  @override
  Future<Coordinates> getCurrentCoordinates() async {
    final l = L10n.current;

    final serviceEnabled = await _isServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException(
        l.errGpsOff,
        LocationErrorKind.serviceDisabled,
      );
    }

    var permission = await _checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
        l.errLocationPermDenied,
        LocationErrorKind.permissionDeniedForever,
      );
    }

    if (permission == LocationPermission.denied) {
      throw LocationServiceException(
        l.errLocationRequired,
        LocationErrorKind.permissionDenied,
      );
    }

    try {
      final position = await _getCurrentPosition();
      return Coordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw LocationServiceException(
        l.errLocationFetch(e.toString()),
        LocationErrorKind.unknown,
      );
    }
  }
}
