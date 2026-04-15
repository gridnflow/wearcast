import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/weather_gradient_background.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '설정',
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
                '기본 설정',
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
                      title: '온도 단위',
                      subtitle: settings.isCelsius ? '섭씨 (°C)' : '화씨 (°F)',
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
                    _SettingsTile(
                      icon: '🥶',
                      title: '추위를 잘 타요',
                      subtitle: '추천 기준을 3°C 낮게 적용합니다',
                      trailing: Switch(
                        value: settings.sensitivityOffset == -3.0,
                        onChanged: (_) => notifier.toggleColdSensitivity(),
                        activeThumbColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              Text(
                '앱 정보',
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
                      title: '개인정보 처리방침',
                      subtitle: '준비 중',
                      onTap: () {},
                    ),
                    Divider(
                      color: AppColors.glassBorder,
                      height: 1,
                      indent: AppSpacing.lg,
                    ),
                    const _SettingsTile(
                      icon: '📱',
                      title: '버전',
                      subtitle: '1.0.0',
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
