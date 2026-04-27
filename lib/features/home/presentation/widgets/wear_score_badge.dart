import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/outfit/domain/entities/outfit.dart';
import '../../../../l10n/app_localizations.dart';

class WearScoreBadge extends StatelessWidget {
  final int score;
  final OutfitCategory category;

  const WearScoreBadge({
    super.key,
    required this.score,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final info = _infoFor(category, l);
    final color = _colorForScore(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(info.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.advice,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _categoryDesc(category, l),
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textOnDark.withAlpha(178),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.hotLabel,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnDark.withAlpha(160),
                  ),
                ),
                Text(
                  l.wearScoreLabel(score),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnDark.withAlpha(160),
                  ),
                ),
                Text(
                  l.coldLabel,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnDark.withAlpha(160),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _ScoreGauge(score: score, color: color),
          ],
        ),
      ],
    );
  }

  Color _colorForScore(int score) {
    if (score >= 80) return const Color(0xFF4758A8);
    if (score >= 65) return const Color(0xFF6E8BC9);
    if (score >= 50) return const Color(0xFF7EC4CF);
    if (score >= 35) return const Color(0xFFB8CE7C);
    if (score >= 20) return const Color(0xFFFFB454);
    return const Color(0xFFFF8A65);
  }

  _ScoreInfo _infoFor(OutfitCategory cat, AppLocalizations l) {
    switch (cat) {
      case OutfitCategory.extremeHot:  return _ScoreInfo('☀️', l.adviceExtremeHot);
      case OutfitCategory.hot:         return _ScoreInfo('🌤️', l.adviceHot);
      case OutfitCategory.warm:        return _ScoreInfo('🌥️', l.adviceWarm);
      case OutfitCategory.mild:        return _ScoreInfo('🍃', l.adviceMild);
      case OutfitCategory.cool:        return _ScoreInfo('🍂', l.adviceCool);
      case OutfitCategory.chilly:      return _ScoreInfo('🌨️', l.adviceChilly);
      case OutfitCategory.cold:        return _ScoreInfo('❄️', l.adviceCold);
      case OutfitCategory.extremeCold: return _ScoreInfo('🌬️', l.adviceExtremeCold);
    }
  }

  String _categoryDesc(OutfitCategory cat, AppLocalizations l) {
    switch (cat) {
      case OutfitCategory.extremeHot:  return l.weatherDescExtremeHot;
      case OutfitCategory.hot:         return l.weatherDescHot;
      case OutfitCategory.warm:        return l.weatherDescWarm;
      case OutfitCategory.mild:        return l.weatherDescMild;
      case OutfitCategory.cool:        return l.weatherDescCool;
      case OutfitCategory.chilly:      return l.weatherDescChilly;
      case OutfitCategory.cold:        return l.weatherDescCold;
      case OutfitCategory.extremeCold: return l.weatherDescExtremeCold;
    }
  }
}

class _ScoreInfo {
  final String emoji;
  final String advice;
  const _ScoreInfo(this.emoji, this.advice);
}

class _ScoreGauge extends StatelessWidget {
  final int score;
  final Color color;

  const _ScoreGauge({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final dotX = (score / 100.0) * w;

        return SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8A65),
                      Color(0xFFFFD166),
                      Color(0xFF7EC4CF),
                      Color(0xFF4758A8),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (dotX - 10).clamp(0.0, w - 20),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(color: color.withAlpha(120), blurRadius: 6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
