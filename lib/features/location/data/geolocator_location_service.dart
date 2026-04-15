import 'package:geolocator/geolocator.dart';

import '../domain/entities/coordinates.dart';
import '../domain/location_service.dart';

/// Geolocator-backed implementation of [LocationService].
///
/// Handles the full permission flow:
/// 1. Confirm location services are enabled.
/// 2. Request permission if not yet granted.
/// 3. Read a single position (not a stream) with medium accuracy.
class GeolocatorLocationService implements LocationService {
  /// Seam for testing; production code uses [Geolocator]'s static methods.
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
        _getCurrentPosition = getCurrentPosition ??
            (() => Geolocator.getCurrentPosition(
                  locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.medium,
                  ),
                ));

  @override
  Future<Coordinates> getCurrentCoordinates() async {
    final serviceEnabled = await _isServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        '위치 서비스(GPS)가 꺼져 있어요. 설정에서 켜주세요.',
        LocationErrorKind.serviceDisabled,
      );
    }

    var permission = await _checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        '위치 권한이 영구 거부되었어요. 설정 > 앱 > 권한에서 허용해 주세요.',
        LocationErrorKind.permissionDeniedForever,
      );
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        '위치 권한이 필요합니다.',
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
        '현재 위치를 가져오지 못했어요: $e',
        LocationErrorKind.unknown,
      );
    }
  }
}
