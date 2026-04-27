import '../../features/weather/domain/entities/weather.dart';

/// Temperature stage (1–8) mapped from feels-like temperature.
///
/// Stage 1: ≤ -5°C  (극한 추위)
/// Stage 2: -5~3°C  (강추위)
/// Stage 3: 3~8°C   (쌀쌀)
/// Stage 4: 8~15°C  (선선)
/// Stage 5: 15~22°C (딱 좋음)
/// Stage 6: 22~27°C (따뜻)
/// Stage 7: 27~32°C (더움)
/// Stage 8: ≥ 32°C  (폭염)
enum WeatherOverlay { rain, snow, wind, sunny, dust }

class CharacterState {
  final int stage;
  final List<WeatherOverlay> overlays;

  const CharacterState({required this.stage, required this.overlays});

  static CharacterState fromWeather(Weather w) {
    return CharacterState(
      stage: _stageFrom(w.feelsLike),
      overlays: _overlaysFrom(w),
    );
  }

  static CharacterState get defaultState =>
      const CharacterState(stage: 5, overlays: [WeatherOverlay.sunny]);

  static int _stageFrom(double feelsLike) {
    if (feelsLike <= -5) return 1;
    if (feelsLike <= 3) return 2;
    if (feelsLike <= 8) return 3;
    if (feelsLike <= 15) return 4;
    if (feelsLike <= 22) return 5;
    if (feelsLike <= 27) return 6;
    if (feelsLike <= 32) return 7;
    return 8;
  }

  static List<WeatherOverlay> _overlaysFrom(Weather w) {
    final overlays = <WeatherOverlay>[];
    final cond = w.condition.toLowerCase();

    if (cond.contains('snow')) overlays.add(WeatherOverlay.snow);
    if (cond.contains('rain') || w.precipitation > 0.1) overlays.add(WeatherOverlay.rain);
    if (cond.contains('dust') || cond.contains('haze') || cond.contains('smoke')) {
      overlays.add(WeatherOverlay.dust);
    }
    if (w.windSpeed > 5) overlays.add(WeatherOverlay.wind);
    if (overlays.isEmpty && (cond.contains('clear') || cond.contains('sun'))) {
      overlays.add(WeatherOverlay.sunny);
    }

    return overlays;
  }

  @override
  bool operator ==(Object other) =>
      other is CharacterState &&
      other.stage == stage &&
      other.overlays.length == overlays.length;

  @override
  int get hashCode => Object.hash(stage, overlays.length);
}
