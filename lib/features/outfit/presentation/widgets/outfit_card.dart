import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/outfit/domain/entities/clothing_item.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Displays a single [ClothingItem] inside a [GlassCard].
class OutfitItemCard extends StatelessWidget {
  final ClothingItem item;

  const OutfitItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.glassFillStrong,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Text(
                _emojiFor(item.bodyPart),
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _labelFor(item.bodyPart),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnDark.withAlpha(179),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _emojiFor(BodyPart part) {
    switch (part) {
      case BodyPart.upper:
        return '👕';
      case BodyPart.lower:
        return '👖';
      case BodyPart.outer:
        return '🧥';
      case BodyPart.shoes:
        return '👟';
      case BodyPart.accessory:
        return '🧣';
    }
  }

  String _labelFor(BodyPart part) {
    switch (part) {
      case BodyPart.upper:
        return '상의';
      case BodyPart.lower:
        return '하의';
      case BodyPart.outer:
        return '아우터';
      case BodyPart.shoes:
        return '신발';
      case BodyPart.accessory:
        return '액세서리';
    }
  }
}
