import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/weather_gradient_background.dart';
import '../providers/settings_provider.dart';

const _privacyPolicyUrl = 'https://gridnflow.github.io/wearcast/privacy.html';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l.settingsTitle,
          style: AppTypography.titleLarge.copyWith(color: AppColors.textOnDark),
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
      ),
      body: WeatherGradientBackground(
        mood: WeatherMood.sunnyMild,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              Text(
                l.basicSettings,
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: '🌡️',
                      title: l.tempUnit,
                      subtitle: settings.isCelsius ? l.celsius : l.fahrenheit,
                      trailing: Switch(
                        value: settings.isCelsius,
                        onChanged: (_) => notifier.toggleTemperatureUnit(),
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                    Divider(
                      color: AppColors.glassBorder,
                      height: 1,
                      indent: AppSpacing.lg,
                    ),
                    _ThermalSensitivityTile(
                      offset: settings.sensitivityOffset,
                      onChanged: notifier.setSensitivity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              Text(
                l.appInfo,
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: '🔒',
                      title: l.privacyPolicy,
                      subtitle: 'gridnflow.github.io/wearcast',
                      trailing: const Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: AppColors.textOnDark,
                      ),
                      onTap: () => _launchPrivacyPolicy(context, l),
                    ),
                    Divider(
                      color: AppColors.glassBorder,
                      height: 1,
                      indent: AppSpacing.lg,
                    ),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snap) {
                        final version = snap.hasData
                            ? '${snap.data!.version} (${snap.data!.buildNumber})'
                            : '1.0.0';
                        return _SettingsTile(
                          icon: '📱',
                          title: l.version,
                          subtitle: version,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchPrivacyPolicy(BuildContext context, AppLocalizations l) async {
    final uri = Uri.parse(_privacyPolicyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.browserOpenFailed)),
        );
      }
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: AppTypography.titleSmall.copyWith(color: AppColors.textOnDark),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textOnDark.withAlpha(179),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// A 3-way thermal-sensitivity selector: cold-sensitive (-3°C) / normal (0) /
/// heat-sensitive (+3°C). Lets users who feel the cold or heat easily nudge the
/// outfit recommendations (and the "bring a cardigan" tip) in either direction.
class _ThermalSensitivityTile extends StatelessWidget {
  final double offset;
  final ValueChanged<double> onChanged;

  const _ThermalSensitivityTile({
    required this.offset,
    required this.onChanged,
  });

  static const _options = <(double, String, String Function(AppLocalizations))>[
    (-3.0, '🥶', _labelCold),
    (0.0, '😊', _labelNormal),
    (3.0, '🥵', _labelHot),
  ];

  static String _labelCold(AppLocalizations l) => l.sensitivityCold;
  static String _labelNormal(AppLocalizations l) => l.sensitivityNormal;
  static String _labelHot(AppLocalizations l) => l.sensitivityHot;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌡️', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.thermalSensitivity,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                    Text(
                      l.thermalSensitivityDesc,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textOnDark.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (final (value, emoji, label) in _options)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _SensitivityChip(
                      emoji: emoji,
                      label: label(l),
                      selected: offset == value,
                      onTap: () => onChanged(value),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SensitivityChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SensitivityChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondary.withAlpha(64)
              : Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.glassBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textOnDark,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
