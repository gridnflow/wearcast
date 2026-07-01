import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Requests an in-app store review once the user has engaged enough to have an
/// opinion, and never more than once.
///
/// Generalises the two variants in the workspace:
///   • wearcast — gate on launch count.
///   • lunar_calendar — gate on a "meaningful event" count *and* days installed.
///
/// Call [recordEngagement] on each meaningful event (app launch, fortune view,
/// task completed …). When both thresholds are met and the store supports it,
/// the review sheet is shown exactly once.
class ReviewService {
  ReviewService({
    String keyPrefix = 'review',
    this.minEngagements = 3,
    this.minDaysInstalled = 3,
    InAppReview? review,
  })  : _keyCount = '${keyPrefix}_engagement_count',
        _keyFirstOpen = '${keyPrefix}_first_open',
        _keyRequested = '${keyPrefix}_requested',
        _review = review ?? InAppReview.instance;

  final int minEngagements;
  final int minDaysInstalled;

  final String _keyCount;
  final String _keyFirstOpen;
  final String _keyRequested;
  final InAppReview _review;

  /// Records one engagement and, if all conditions are met, requests a review.
  /// Returns true only when the review sheet was actually shown.
  Future<bool> recordEngagement() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_keyRequested) ?? false) return false;

    final now = DateTime.now();
    if (!prefs.containsKey(_keyFirstOpen)) {
      await prefs.setString(_keyFirstOpen, now.toIso8601String());
    }

    final count = (prefs.getInt(_keyCount) ?? 0) + 1;
    await prefs.setInt(_keyCount, count);
    if (count < minEngagements) return false;

    final firstOpen = DateTime.parse(prefs.getString(_keyFirstOpen)!);
    if (now.difference(firstOpen).inDays < minDaysInstalled) return false;

    if (await _review.isAvailable()) {
      await _review.requestReview();
      await prefs.setBool(_keyRequested, true);
      return true;
    }
    return false;
  }

  /// Opens the store listing directly (e.g. from a "Rate us" settings row).
  Future<void> openStoreListing({String? appStoreId}) =>
      _review.openStoreListing(appStoreId: appStoreId);
}
