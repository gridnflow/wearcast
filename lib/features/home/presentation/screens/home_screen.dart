import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/location/domain/entities/coordinates.dart';
import '../../../../features/location/presentation/providers/location_providers.dart';
import '../../../../features/outfit/domain/entities/outfit.dart';
import '../../../../features/outfit/presentation/providers/outfit_provider.dart';
import '../../../../features/outfit/presentation/widgets/outfit_card.dart';
import '../../../../features/weather/domain/entities/forecast.dart';
import '../../../../features/weather/domain/entities/weather.dart';
import '../../../../features/weather/presentation/providers/weather_providers.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/loading_indicator.dart' show LoadingIndicator;
import '../../../../shared/widgets/weather_gradient_background.dart';
import '../../../../core/character/character_state.dart';
import '../widgets/weather_character.dart';
import '../widgets/wear_score_badge.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Selected hour index for the layering slider (0=morning,1=afternoon,2=evening).
  int _timeSlot = 0;

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(currentCoordinatesProvider);

    return locationAsync.when(
      loading: () => const Scaffold(
        body: Center(child: LoadingIndicator(message: '위치를 가져오는 중...')),
      ),
      error: (e, _) => Scaffold(
        body: AppErrorView(
          message: '위치 권한이 필요합니다.\n$e',
          onRetry: () => ref.invalidate(currentCoordinatesProvider),
        ),
      ),
      data: (coords) => _WeatherBody(
        coords: coords,
        timeSlot: _timeSlot,
        onTimeSlotChanged: (v) => setState(() => _timeSlot = v),
      ),
    );
  }
}

class _WeatherBody extends ConsumerWidget {
  final Coordinates coords;
  final int timeSlot;
  final ValueChanged<int> onTimeSlotChanged;

  const _WeatherBody({
    required this.coords,
    required this.timeSlot,
    required this.onTimeSlotChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = WeatherQuery(
      latitude: coords.latitude,
      longitude: coords.longitude,
    );
    final weatherAsync = ref.watch(currentWeatherProvider(query));
    final forecastAsync = ref.watch(forecastProvider(query));

    return weatherAsync.when(
      loading: () => const Scaffold(
        body: Center(child: LoadingIndicator(message: '날씨를 불러오는 중...')),
      ),
      error: (e, _) => Scaffold(
        body: AppErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(currentWeatherProvider(query)),
        ),
      ),
      data: (weather) {
        final forecast = forecastAsync.valueOrNull;
        final effectiveWeather = _weatherForSlot(weather, forecast, timeSlot);
        final outfit = ref.watch(outfitForWeatherProvider(effectiveWeather));
        final mood = _moodFrom(effectiveWeather, timeSlot);
        final characterState = CharacterState.fromWeather(effectiveWeather);

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context, weather.cityName),
          body: WeatherGradientBackground(
            mood: mood,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.lg,
                ),
                children: [
                  _WeatherHeroSection(
                    weather: effectiveWeather,
                    outfit: outfit,
                    characterState: characterState,
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _TimeSlider(
                    selectedIndex: timeSlot,
                    onChanged: onTimeSlotChanged,
                    forecast: forecast,
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _OutfitSection(outfit: outfit),
                  const SizedBox(height: AppSpacing.xl3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, String cityName) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        cityName,
        style: AppTypography.titleLarge.copyWith(color: AppColors.textOnDark),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: AppColors.textOnDark),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }

  Weather _weatherForSlot(Weather current, Forecast? forecast, int slot) {
    if (forecast == null || forecast.hourly.isEmpty || slot == 0) return current;
    final now = DateTime.now();
    final targetHour = slot == 1 ? 14 : 19;
    // Find the closest hourly entry to the target hour today.
    final entries = forecast.hourly.where((e) {
      return e.dateTime.day == now.day && e.dateTime.hour >= targetHour;
    }).toList();
    if (entries.isEmpty) return current;
    return entries.first.toWeather(current.cityName);
  }

  WeatherMood _moodFrom(Weather w, int slot) {
    final cond = w.condition.toLowerCase();
    final hour = slot == 0 ? 9 : (slot == 1 ? 14 : 19);

    if (cond.contains('snow')) return WeatherMood.snowy;
    if (cond.contains('rain') || w.precipitation > 0.1) return WeatherMood.rainy;
    if (cond.contains('dust') || cond.contains('haze') || cond.contains('smoke')) {
      return WeatherMood.dust;
    }
    if (cond.contains('cloud')) return WeatherMood.cloudy;
    if (hour >= 20 || hour < 6) return WeatherMood.night;
    if (w.temperature >= 23) return WeatherMood.sunnyWarm;
    if (w.temperature <= 8) return WeatherMood.cold;
    return WeatherMood.sunnyMild;
  }
}

// ---------------------------------------------------------------------------
// Hero section
// ---------------------------------------------------------------------------

class _WeatherHeroSection extends StatelessWidget {
  final Weather weather;
  final Outfit outfit;
  final CharacterState characterState;

  const _WeatherHeroSection({
    required this.weather,
    required this.outfit,
    required this.characterState,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°',
                      style: AppTypography.displayLarge.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                    Text(
                      '체감 ${weather.feelsLike.round()}°',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textOnDark.withAlpha(204),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      weather.description,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                  ],
                ),
              ),
              WeatherCharacter(state: characterState, size: 120),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WeatherStat(
                label: '습도',
                value: '${weather.humidity}%',
                icon: '💧',
              ),
              _WeatherStat(
                label: '풍속',
                value: '${weather.windSpeed.toStringAsFixed(1)}m/s',
                icon: '💨',
              ),
              _WeatherStat(
                label: '강수',
                value: '${weather.precipitation.toStringAsFixed(1)}mm',
                icon: '🌧️',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          WearScoreBadge(score: outfit.wearScore, category: outfit.category),
        ],
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _WeatherStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.labelLarge.copyWith(color: AppColors.textOnDark),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textOnDark.withAlpha(179),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Time slot slider
// ---------------------------------------------------------------------------

class _TimeSlider extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Forecast? forecast;

  static const _labels = ['오전', '오후', '저녁'];

  const _TimeSlider({
    required this.selectedIndex,
    required this.onChanged,
    this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '시간대별 옷차림',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(_labels.length, (i) {
              final selected = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: AppDuration.fast,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.glassFillStrong
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: selected
                          ? Border.all(color: AppColors.glassBorder)
                          : null,
                    ),
                    child: Text(
                      _labels[i],
                      textAlign: TextAlign.center,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Outfit section
// ---------------------------------------------------------------------------

class _OutfitSection extends StatelessWidget {
  final Outfit outfit;

  const _OutfitSection({required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘의 추천 옷차림',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (outfit.tip.isNotEmpty)
          GlassCard(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    outfit.tip,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: outfit.items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => OutfitItemCard(item: outfit.items[i]),
        ),
      ],
    );
  }
}
