/// Base for exceptions thrown in the data layer before they are mapped to a
/// [Failure]. Mirrors the `AppException` in real_time_translation and the
/// `*Exception` set in wearcast, unified into one hierarchy.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}
