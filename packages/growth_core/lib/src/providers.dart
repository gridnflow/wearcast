import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/ad_ids.dart';
import 'ads/ad_service.dart';
import 'prefs/prefs_service.dart';
import 'review/review_service.dart';

/// Ad configuration for the current app. Override in the app's `ProviderScope`:
///
/// ```dart
/// ProviderScope(overrides: [
///   adConfigProvider.overrideWithValue(const AdConfig(android: ..., ios: ...)),
/// ], child: MyApp());
/// ```
final adConfigProvider = Provider<AdConfig>((ref) => const AdConfig.test());

final adServiceProvider = Provider<AdService>((ref) {
  final service = AdService(ref.watch(adConfigProvider));
  ref.onDispose(service.dispose);
  return service;
});

final reviewServiceProvider = Provider<ReviewService>((ref) => ReviewService());

/// Must be overridden with a resolved instance in `main()`:
///
/// ```dart
/// final prefs = await PrefsService.create();
/// runApp(ProviderScope(overrides: [
///   prefsServiceProvider.overrideWithValue(prefs),
/// ], child: MyApp()));
/// ```
final prefsServiceProvider = Provider<PrefsService>(
  (ref) => throw UnimplementedError('prefsServiceProvider must be overridden'),
);

/// Raw [SharedPreferences] escape hatch, override the same way as above.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);
