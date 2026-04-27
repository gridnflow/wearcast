import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/outfit/domain/entities/clothing_item.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/glass_card.dart';

class OutfitItemCard extends StatelessWidget {
  final ClothingItem item;

  const OutfitItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                  _labelFor(item.bodyPart, l),
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
      case BodyPart.upper:     return '👕';
      case BodyPart.lower:     return '👖';
      case BodyPart.outer:     return '🧥';
      case BodyPart.shoes:     return '👟';
      case BodyPart.accessory: return '🧣';
    }
  }

  String _labelFor(BodyPart part, AppLocalizations l) {
    switch (part) {
      case BodyPart.upper:     return l.bodyPartUpper;
      case BodyPart.lower:     return l.bodyPartLower;
      case BodyPart.outer:     return l.bodyPartOuter;
      case BodyPart.shoes:     return l.bodyPartShoes;
      case BodyPart.accessory: return l.bodyPartAccessory;
    }
  }
}
