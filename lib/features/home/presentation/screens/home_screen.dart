import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/character/character_state.dart';
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
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/loading_indicator.dart' show LoadingIndicator;
import '../../../../shared/widgets/weather_gradient_background.dart';
import '../widgets/wear_score_badge.dart';
import '../widgets/weather_character.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _timeSlot = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locationAsync = ref.watch(currentCoordinatesProvider);

    return locationAsync.when(
      loading: () => Scaffold(
        body: Center(child: LoadingIndicator(message: l.loadingLocation)),
      ),
      error: (e, _) => Scaffold(
        body: AppErrorView(
          message: e.toString(),
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
    final l = AppLocalizations.of(context);
    final query = WeatherQuery(
      latitude: coords.latitude,
      longitude: coords.longitude,
    );
    final weatherAsync = ref.watch(currentWeatherProvider(query));
    final forecastAsync = ref.watch(forecastProvider(query));

    return weatherAsync.when(
      loading: () => Scaffold(
        body: Center(child: LoadingIndicator(message: l.loadingWeather)),
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
        final contentColor = mood.contentColor;
        final characterState = CharacterState.fromWeather(effectiveWeather);

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context, weather.cityName, contentColor),
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
                    textColor: contentColor,
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _TimeSlider(
                    selectedIndex: timeSlot,
                    onChanged: onTimeSlotChanged,
                    forecast: forecast,
                    textColor: contentColor,
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _RainForecastSection(forecast: forecast, textColor: contentColor),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _OutfitSection(outfit: outfit, textColor: contentColor),
                  const SizedBox(height: AppSpacing.xl3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, String cityName, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        cityName,
        style: AppTypography.titleLarge.copyWith(color: textColor),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined, color: textColor),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }

  Weather _weatherForSlot(Weather current, Forecast? forecast, int slot) {
    if (forecast == null || forecast.hourly.isEmpty || slot == 0) return current;
    final now = DateTime.now();
    final targetHour = slot == 1 ? 14 : 19;
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
  final Color textColor;

  const _WeatherHeroSection({
    required this.weather,
    required this.outfit,
    required this.characterState,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                      style: AppTypography.displayLarge.copyWith(color: textColor),
                    ),
                    Text(
                      l.feelsLike(weather.feelsLike.round()),
                      style: AppTypography.bodyMedium.copyWith(
                        color: textColor.withAlpha(204),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      weather.description,
                      style: AppTypography.titleSmall.copyWith(color: textColor),
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
                label: l.humidity,
                value: '${weather.humidity}%',
                icon: '💧',
                textColor: textColor,
              ),
              _WeatherStat(
                label: l.windSpeed,
                value: '${weather.windSpeed.toStringAsFixed(1)}m/s',
                icon: '💨',
                textColor: textColor,
              ),
              _WeatherStat(
                label: l.precipitation,
                value: '${weather.precipitation.toStringAsFixed(1)}mm',
                icon: '🌧️',
                textColor: textColor,
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
  final Color textColor;

  const _WeatherStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTypography.labelLarge.copyWith(color: textColor)),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: textColor.withAlpha(179),
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
  final Color textColor;

  const _TimeSlider({
    required this.selectedIndex,
    required this.onChanged,
    required this.textColor,
    this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = [l.slotMorning, l.slotAfternoon, l.slotEvening];

    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.timeSlotTitle,
            style: AppTypography.titleSmall.copyWith(color: textColor),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(labels.length, (i) {
              final selected = i == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: AppDuration.fast,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.glassFillStrong : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: selected ? Border.all(color: AppColors.glassBorder) : null,
                    ),
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: AppTypography.labelLarge.copyWith(
                        color: textColor,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
  final Color textColor;

  const _OutfitSection({required this.outfit, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.outfitTitle,
          style: AppTypography.headlineSmall.copyWith(color: textColor),
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
                    style: AppTypography.bodyMedium.copyWith(color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: outfit.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => OutfitItemCard(item: outfit.items[i]),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Rain forecast section
// ---------------------------------------------------------------------------

class _RainForecastSection extends StatelessWidget {
  final Forecast? forecast;
  final Color textColor;

  const _RainForecastSection({this.forecast, required this.textColor});

  @override
  Widget build(BuildContext context) {
    if (forecast == null || forecast!.hourly.isEmpty) return const SizedBox.shrink();

    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    final todayEntries = forecast!.hourly.where((e) =>
      e.dateTime.year == now.year &&
      e.dateTime.month == now.month &&
      e.dateTime.day == now.day &&
      e.dateTime.isAfter(now.subtract(const Duration(minutes: 30))),
    ).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (todayEntries.isEmpty) return const SizedBox.shrink();

    final rainEntries = todayEntries.where((e) =>
      e.precipitation > 0.1 ||
      e.condition.toLowerCase().contains('rain') ||
      e.condition.toLowerCase().contains('drizzle') ||
      e.condition.toLowerCase().contains('thunderstorm'),
    ).toList();

    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌧️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  rainEntries.isEmpty
                      ? l.noRainToday
                      : _rainMessage(rainEntries, l),
                  style: AppTypography.titleSmall.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _HourlyRainBar(entries: todayEntries, now: now, textColor: textColor),
        ],
      ),
    );
  }

  String _rainMessage(List<ForecastEntry> rainEntries, AppLocalizations l) {
    final first = rainEntries.first.dateTime;
    final last = rainEntries.last.dateTime;
    final start = _hourLabel(first, l);
    if (first.hour == last.hour) return l.rainAt(start);
    return l.rainBetween(start, _hourLabel(last, l));
  }

  String _hourLabel(DateTime dt, AppLocalizations l) {
    final h = dt.hour;
    if (h == 0) return l.midnight;
    if (h < 12) return l.amHour(h);
    if (h == 12) return l.pmNoon;
    return l.pmHour(h - 12);
  }
}

class _HourlyRainBar extends StatelessWidget {
  final List<ForecastEntry> entries;
  final DateTime now;
  final Color textColor;

  const _HourlyRainBar({
    required this.entries,
    required this.now,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: entries.map((e) {
        final isRain = e.precipitation > 0.1 ||
            e.condition.toLowerCase().contains('rain') ||
            e.condition.toLowerCase().contains('drizzle') ||
            e.condition.toLowerCase().contains('thunderstorm');
        final isPast = e.dateTime.isBefore(now);
        final isCurrent = e.dateTime.hour == now.hour;
        final barHeight = isRain
            ? (4.0 + (e.precipitation * 6).clamp(0.0, 20.0))
            : 4.0;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: isRain
                        ? (isPast
                            ? const Color(0x557EC8F0)
                            : const Color(0xFF7EC8F0))
                        : Colors.white.withAlpha(isPast ? 30 : 50),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                if (e.dateTime.hour % 3 == 0)
                  Text(
                    e.dateTime.hour == 0
                        ? '0'
                        : '${e.dateTime.hour}',
                    style: TextStyle(
                      fontSize: 9,
                      color: isCurrent
                          ? textColor
                          : textColor.withAlpha(isPast ? 80 : 140),
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                    ),
                  )
                else
                  const SizedBox(height: 12),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
