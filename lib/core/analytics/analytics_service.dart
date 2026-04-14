import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wrapper around Firebase Analytics.
///
/// Centralizes event logging and provides a single point for enabling/disabling
/// analytics collection (e.g., for debug builds or user opt-out).
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  FirebaseAnalytics get instance => _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[Analytics] Failed to log event "$name": $e');
      }
    }
  }

  Future<void> logAppOpen() => _analytics.logAppOpen();

  Future<void> logScreenView({required String screenName}) =>
      _analytics.logScreenView(screenName: screenName);

  Future<void> logWeatherFetched({
    required String condition,
    required double temperature,
  }) =>
      logEvent('weather_fetched', parameters: {
        'condition': condition,
        'temperature': temperature,
      });

  Future<void> logOutfitViewed({
    required String category,
    required double temperature,
  }) =>
      logEvent('outfit_viewed', parameters: {
        'category': category,
        'temperature': temperature,
      });
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(FirebaseAnalytics.instance);
});
