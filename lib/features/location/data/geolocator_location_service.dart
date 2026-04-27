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
        _getCurrentPosition = getCurrentPosition ??
            (() => Geolocator.getCurrentPosition(
                  locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.medium,
                    timeLimit: Duration(seconds: 10),
                  ),
                ).catchError((e) async {
                  final last = await Geolocator.getLastKnownPosition();
                  if (last != null) return last;
                  throw e;
                }));

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
