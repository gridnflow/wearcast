import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/outfit/domain/entities/outfit.dart';

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
    final info = _infoFor(category);
    final color = _colorForScore(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카테고리 + 조언
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
                    '${category.label} 날씨예요',
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

        // 게이지 바
        Column(
          children: [
            // 라벨
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🥵 더움',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnDark.withAlpha(160),
                  ),
                ),
                Text(
                  '옷차림 지수 $score',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnDark.withAlpha(160),
                  ),
                ),
                Text(
                  '추움 🥶',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnDark.withAlpha(160),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // 게이지
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

  _ScoreInfo _infoFor(OutfitCategory cat) {
    switch (cat) {
      case OutfitCategory.extremeHot:
        return const _ScoreInfo('☀️', '최대한 얇게 입으세요');
      case OutfitCategory.hot:
        return const _ScoreInfo('🌤️', '반팔·반바지면 충분해요');
      case OutfitCategory.warm:
        return const _ScoreInfo('🌥️', '가볍게 입어도 돼요');
      case OutfitCategory.mild:
        return const _ScoreInfo('🍃', '가벼운 겉옷을 준비하세요');
      case OutfitCategory.cool:
        return const _ScoreInfo('🍂', '겉옷을 꼭 챙기세요');
      case OutfitCategory.chilly:
        return const _ScoreInfo('🌨️', '두꺼운 겉옷이 필요해요');
      case OutfitCategory.cold:
        return const _ScoreInfo('❄️', '따뜻하게 입으세요');
      case OutfitCategory.extremeCold:
        return const _ScoreInfo('🌬️', '최대한 두껍게 입으세요');
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
        final ratio = score / 100.0;
        final dotX = ratio * w;

        return SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // 그라디언트 바
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF8A65), // 더움 (score 0)
                      Color(0xFFFFD166), // 따뜻
                      Color(0xFF7EC4CF), // 선선
                      Color(0xFF4758A8), // 추움 (score 100)
                    ],
                  ),
                ),
              ),
              // 포지션 인디케이터
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
                      BoxShadow(
                        color: color.withAlpha(120),
                        blurRadius: 6,
                      ),
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
