# growth_core

Shared building blocks extracted from the duplicated `core/` layers across the
workspace's Flutter apps (`lunar_calendar`, `todo`, `real_time_translation`,
`sparfinder`, `wearcast`, `game`). One package, one barrel import.

```dart
import 'package:growth_core/growth_core.dart';
```

## What's inside

| Module | Replaces (per-app copies) | API |
|--------|---------------------------|-----|
| **Result** | `wearcast/core/utils/result.dart` | `Result<T>`, `Ok`, `Err`, `.fold`, `.map` |
| **Failure** | `Failure` hierarchies in wearcast/game/rtt | `ServerFailure`, `CacheFailure`, `NetworkFailure`, `UnknownFailure` |
| **AppException** | `rtt/core/errors/app_exception.dart`, wearcast exceptions | `ServerException`, `CacheException`, `NetworkException` |
| **AdService** | ad_service in lunar/todo (+ rtt/sparfinder/wearcast) | banner / interstitial / rewarded lifecycle |
| **BannerAdWidget** | `todo/core/widgets/banner_ad_widget.dart` | self-loading/disposing banner |
| **ReviewService** | review_service in wearcast + lunar | engagement + days-installed gating |
| **Dio** | `wearcast/core/network/dio_client.dart` | `buildDioClient(...)` |
| **Connectivity** | rtt `connectivityProvider`, wearcast `NetworkInfo` | `NetworkInfo`, `connectivityStreamProvider` |
| **PrefsService** | ad-hoc `SharedPreferences` calls everywhere | typed get/set + JSON helpers |
| **AppSpacing** | `wearcast/core/theme/app_spacing.dart` | 4pt scale, radii, gaps |

> **Not extracted on purpose:** brand colours, typography, `app_router`,
> domain models/services (`lunar_service`, `fortune_service`, weather DTOs …).
> Those are app-specific — keep them in each app's `core/`.

## Adopting it in an app

1. Add the path dependency in the app's `pubspec.yaml`:
   ```yaml
   dependencies:
     growth_core:
       path: ../packages/growth_core
   ```
2. Override the injected providers in `main()`:
   ```dart
   final prefs = await PrefsService.create();
   runApp(ProviderScope(
     overrides: [
       prefsServiceProvider.overrideWithValue(prefs),
       adConfigProvider.overrideWithValue(
         const AdConfig(android: AdIds(banner: '...'), ios: AdIds(banner: '...')),
       ),
     ],
     child: const MyApp(),
   ));
   ```
3. Delete the app's now-redundant `core/` files and re-point imports to
   `package:growth_core/growth_core.dart`.

## Dev

```bash
flutter pub get
flutter analyze   # clean
flutter test      # Result/Failure coverage
```
