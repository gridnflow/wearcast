import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isCelsius;

  /// Sensitivity offset in °C. Positive = user runs warm, negative = cold-sensitive.
  /// "나는 추위를 잘 탄다" toggle sets this to -3.0.
  final double sensitivityOffset;

  const SettingsState({
    this.isCelsius = true,
    this.sensitivityOffset = 0.0,
  });

  SettingsState copyWith({
    bool? isCelsius,
    double? sensitivityOffset,
  }) {
    return SettingsState(
      isCelsius: isCelsius ?? this.isCelsius,
      sensitivityOffset: sensitivityOffset ?? this.sensitivityOffset,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const _keyCelsius = 'settings_is_celsius';
  static const _keySensitivity = 'settings_sensitivity';

  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      isCelsius: prefs.getBool(_keyCelsius) ?? true,
      sensitivityOffset: prefs.getDouble(_keySensitivity) ?? 0.0,
    );
  }

  Future<void> toggleTemperatureUnit() async {
    final updated = state.copyWith(isCelsius: !state.isCelsius);
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCelsius, updated.isCelsius);
  }

  Future<void> toggleColdSensitivity() async {
    final newOffset = state.sensitivityOffset == -3.0 ? 0.0 : -3.0;
    state = state.copyWith(sensitivityOffset: newOffset);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keySensitivity, newOffset);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
