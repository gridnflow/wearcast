import 'package:flutter/material.dart';

import '../../../../shared/widgets/weather_gradient_background.dart';

/// Weather-state-driven avatar placeholder.
///
/// Shows an emoji-based illustration for each [WeatherMood].
/// Designed to be replaced by a Lottie animation in a later phase —
/// callers depend only on the [WeatherMood] input parameter.
class DailyAvatar extends StatelessWidget {
  final WeatherMood mood;
  final double size;

  const DailyAvatar({
    super.key,
    required this.mood,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    final data = _avatarDataFor(mood);
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.figure,
            style: TextStyle(fontSize: size * 0.48),
          ),
          const SizedBox(height: 4),
          Text(
            data.accessory,
            style: TextStyle(fontSize: size * 0.24),
          ),
        ],
      ),
    );
  }

  _AvatarData _avatarDataFor(WeatherMood mood) {
    switch (mood) {
      case WeatherMood.sunnyWarm:
        return const _AvatarData(figure: '🧍', accessory: '😎🌤️');
      case WeatherMood.sunnyMild:
        return const _AvatarData(figure: '🚶', accessory: '☀️');
      case WeatherMood.cold:
        return const _AvatarData(figure: '🧥', accessory: '🥶🧣');
      case WeatherMood.cloudy:
        return const _AvatarData(figure: '🚶', accessory: '☁️');
      case WeatherMood.rainy:
        return const _AvatarData(figure: '🧍', accessory: '🌂🥾');
      case WeatherMood.snowy:
        return const _AvatarData(figure: '🧍', accessory: '⛄🧤');
      case WeatherMood.dust:
        return const _AvatarData(figure: '🧍', accessory: '😷🌫️');
      case WeatherMood.night:
        return const _AvatarData(figure: '🌙', accessory: '🧥⭐');
    }
  }
}

class _AvatarData {
  final String figure;
  final String accessory;
  const _AvatarData({required this.figure, required this.accessory});
}
