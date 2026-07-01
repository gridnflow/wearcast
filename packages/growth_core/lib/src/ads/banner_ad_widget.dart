import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_service.dart';

/// Drop-in banner that loads on mount and disposes on unmount, reserving space
/// only once the ad is ready. Replaces todo's `banner_ad_widget.dart`.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({
    super.key,
    required this.adService,
    this.size = AdSize.banner,
  });

  final AdService adService;
  final AdSize size;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = widget.adService.createBanner(
      size: widget.size,
      onLoaded: (_) {
        if (mounted) setState(() => _loaded = true);
      },
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
