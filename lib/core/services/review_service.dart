import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Requests an in-app review after the user has had enough meaningful
/// sessions to form an opinion about the app.
///
/// Rules (all must pass):
///   1. App has been launched at least [_minLaunches] times.
///   2. Review has never been requested before.
///   3. The device/store actually supports in-app review.
class ReviewService {
  static const _keyLaunchCount = 'review_launch_count';
  static const _keyReviewRequested = 'review_requested';
  static const _minLaunches = 5;

  final InAppReview _review;

  ReviewService({InAppReview? review})
      : _review = review ?? InAppReview.instance;

  /// Call once per app launch (e.g. from HomeScreen initState).
  Future<void> onAppLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    // Don't count if review was already shown.
    if (prefs.getBool(_keyReviewRequested) == true) return;

    final count = (prefs.getInt(_keyLaunchCount) ?? 0) + 1;
    await prefs.setInt(_keyLaunchCount, count);

    if (count >= _minLaunches) {
      await _maybeRequestReview(prefs);
    }
  }

  Future<void> _maybeRequestReview(SharedPreferences prefs) async {
    final isAvailable = await _review.isAvailable();
    if (!isAvailable) return;

    await _review.requestReview();
    await prefs.setBool(_keyReviewRequested, true);
  }
}
