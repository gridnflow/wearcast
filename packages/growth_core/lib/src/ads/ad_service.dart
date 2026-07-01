import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';

/// Unified AdMob wrapper covering banner, interstitial and rewarded ads.
///
/// Consolidates the per-app implementations (lunar_calendar, todo,
/// real_time_translation, sparfinder, wearcast) which each re-wrote the same
/// load/show/dispose lifecycle. Construct once with an [AdConfig] and share it
/// (see `adServiceProvider`).
class AdService {
  AdService(this.config);

  final AdConfig config;

  bool _initialized = false;
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  AdIds get _ids => config.current;

  Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    if (kDebugMode) debugPrint('[AdService] initialized');
    // Warm the cache so the first show() is instant.
    unawaited(loadInterstitial());
    unawaited(loadRewarded());
  }

  // ── Banner ────────────────────────────────────────────────────────────────

  /// Builds an unloaded [BannerAd]. Call `.load()` on the result and dispose it
  /// when the hosting widget is disposed (see [BannerAdWidget]).
  BannerAd createBanner({
    AdSize size = AdSize.banner,
    void Function(Ad)? onLoaded,
    void Function(Ad, LoadAdError)? onFailed,
  }) {
    return BannerAd(
      adUnitId: _ids.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded?.call(ad),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          onFailed?.call(ad, err);
        },
      ),
    );
  }

  // ── Interstitial ────────────────────────────────────────────────────────

  Future<void> loadInterstitial() async {
    if (_ids.interstitial.isEmpty) return;
    await InterstitialAd.load(
      adUnitId: _ids.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  /// Shows the cached interstitial (if any) and pre-loads the next one.
  void showInterstitial() {
    final ad = _interstitial;
    _interstitial = null;
    ad?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        unawaited(loadInterstitial());
      },
    );
    ad?.show();
  }

  // ── Rewarded ──────────────────────────────────────────────────────────────

  Future<void> loadRewarded() async {
    if (_ids.rewarded.isEmpty) return;
    await RewardedAd.load(
      adUnitId: _ids.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  /// Shows the rewarded ad, invoking [onReward] on completion. If no ad is
  /// loaded the reward is granted immediately so UX never dead-ends — matching
  /// the fallback behaviour lunar_calendar relied on.
  void showRewarded({required VoidCallback onReward}) {
    final ad = _rewarded;
    _rewarded = null;
    if (ad == null) {
      onReward();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        unawaited(loadRewarded());
      },
    );
    ad.show(onUserEarnedReward: (_, __) => onReward());
  }

  void dispose() {
    _interstitial?.dispose();
    _rewarded?.dispose();
    _interstitial = null;
    _rewarded = null;
  }
}
