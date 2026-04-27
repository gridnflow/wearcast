import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

class AppErrorView extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const AppErrorView({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.cloud_off_rounded,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
              child: Icon(icon, size: 36, color: AppColors.primaryDark),
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
                child: Text(retryLabel ?? l.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
