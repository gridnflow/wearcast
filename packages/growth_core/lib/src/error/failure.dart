/// Base type for domain-layer failures passed across layer boundaries.
///
/// Extracted from the near-identical `Failure` hierarchies that each app
/// re-declared (wearcast, game, real_time_translation …). Apps add their own
/// domain-specific subclasses by extending [Failure] locally.
sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failure &&
          other.runtimeType == runtimeType &&
          other.message == message);

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

/// A remote/server-side error (non-2xx response, malformed payload, …).
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// A local cache/storage read or write error.
final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// No connectivity or a transport-level error.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Location permission denied or position lookup failed.
final class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

/// Fallback for anything not covered above.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error']);
}
