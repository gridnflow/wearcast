import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Friendly error state used across the app.
///
/// Pairs a rounded illustration-style icon with a short message and an
/// optional retry CTA. Sized to work both as a full-screen state and inside
/// a smaller card.
class AppErrorView extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;

  const AppErrorView({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.cloud_off_rounded,
    this.onRetry,
    this.retryLabel = '다시 시도',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (title != null) ...[
              Text(
                title!,
                style: AppTypography.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: onRetry,
                child: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
