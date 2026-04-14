import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A translucent, blurred card — the primary surface style for screens that
/// sit on top of a [WeatherGradientBackground].
///
/// Uses a [BackdropFilter] to blur whatever sits beneath, a soft white fill,
/// and a subtle border that echoes a frosted-glass edge.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurSigma;

  /// Intensity of the inner fill. Use [strong] = true over busy/vivid
  /// backgrounds where content needs extra contrast.
  final bool strong;

  /// Optional fixed width/height — normally the card sizes to its child.
  final double? width;
  final double? height;

  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.margin,
    this.borderRadius = AppRadius.xl,
    this.blurSigma = AppElevation.glassBlur,
    this.strong = false,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final fill = strong ? AppColors.glassFillStrong : AppColors.glassFill;

    final card = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: radius,
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: const [
              BoxShadow(
                color: AppColors.glassShadow,
                blurRadius: AppElevation.lg,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    final wrapped = onTap == null
        ? card
        : Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: card,
            ),
          );

    if (margin == null) return wrapped;
    return Padding(padding: margin!, child: wrapped);
  }
}
