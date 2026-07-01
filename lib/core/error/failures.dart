// Failure types now live in growth_core. Re-exported here so existing imports
// (`core/error/failures.dart`) keep working. LocationFailure is included.
export 'package:growth_core/growth_core.dart'
    show Failure, ServerFailure, CacheFailure, NetworkFailure, LocationFailure;
