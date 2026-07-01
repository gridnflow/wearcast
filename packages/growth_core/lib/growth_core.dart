/// growth_core — shared building blocks reused across the workspace's Flutter
/// apps (lunar_calendar, todo, real_time_translation, sparfinder, wearcast,
/// game). Import this single barrel:
///
/// ```dart
/// import 'package:growth_core/growth_core.dart';
/// ```
library growth_core;

// Result & errors
export 'src/result/result.dart';
export 'src/error/failure.dart';
export 'src/error/app_exception.dart';

// Ads
export 'src/ads/ad_ids.dart';
export 'src/ads/ad_service.dart';
export 'src/ads/banner_ad_widget.dart';

// Review
export 'src/review/review_service.dart';

// Network
export 'src/network/dio_client.dart';
export 'src/network/connectivity.dart';

// Prefs
export 'src/prefs/prefs_service.dart';

// Theme tokens
export 'src/theme/app_spacing.dart';

// Riverpod providers
export 'src/providers.dart';
