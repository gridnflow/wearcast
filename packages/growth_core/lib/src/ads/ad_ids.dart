import 'dart:io';

/// AdMob unit ids for one platform. Supply real ids per app; the Google test
/// ids are exposed via [AdIds.test] for development.
class AdIds {
  final String banner;
  final String interstitial;
  final String rewarded;

  const AdIds({
    this.banner = '',
    this.interstitial = '',
    this.rewarded = '',
  });

  /// Google's official test unit ids — safe to ship in debug builds only.
  static const AdIds test = AdIds(
    banner: 'ca-app-pub-3940256099942544/6300978111',
    interstitial: 'ca-app-pub-3940256099942544/1033173712',
    rewarded: 'ca-app-pub-3940256099942544/5224354917',
  );
}

/// Platform-aware bundle of [AdIds]. Falls back to [AdIds.test] on any
/// platform without explicit ids so development never crashes on empty units.
class AdConfig {
  final AdIds android;
  final AdIds ios;

  const AdConfig({this.android = AdIds.test, this.ios = AdIds.test});

  const AdConfig.test()
      : android = AdIds.test,
        ios = AdIds.test;

  AdIds get current {
    if (Platform.isIOS) return ios;
    return android;
  }
}
