import 'package:growth_core/growth_core.dart' as core;

/// Thin adapter over growth_core's [core.ReviewService], preserving wearcast's
/// original API and gating (5 launches, no day requirement).
class ReviewService {
  ReviewService({core.ReviewService? delegate})
      : _delegate = delegate ??
            core.ReviewService(minEngagements: 5, minDaysInstalled: 0);

  final core.ReviewService _delegate;

  /// Call once per app launch (e.g. from HomeScreen initState).
  Future<void> onAppLaunch() => _delegate.recordEngagement();
}
