import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/outfit/domain/entities/outfit.dart';

/// A pill-shaped badge that displays the Wear-Score (0–100) and the outfit
/// category label. Color shifts from cool to warm based on score.
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
    final color = _colorForScore(score);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withAlpha(128), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score',
            style: AppTypography.displaySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'WEAR',
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                category.label,
                style: AppTypography.labelMedium.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _colorForScore(int score) {
    if (score >= 80) return AppColors.accentForCategory('extreme_cold');
    if (score >= 65) return AppColors.accentForCategory('cold');
    if (score >= 50) return AppColors.accentForCategory('chilly');
    if (score >= 35) return AppColors.accentForCategory('cool');
    if (score >= 20) return AppColors.accentForCategory('warm');
    return AppColors.accentForCategory('hot');
  }
}
