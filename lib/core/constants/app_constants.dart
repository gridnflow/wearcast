class AppConstants {
  AppConstants._();

  static const String appName = 'WearCast';

  /// Temperature ranges for outfit recommendation (°C)
  static const List<TemperatureRangeConfig> temperatureRanges = [
    TemperatureRangeConfig(min: 28, max: 50, label: '한여름', category: 'extreme_hot'),
    TemperatureRangeConfig(min: 23, max: 27, label: '여름', category: 'hot'),
    TemperatureRangeConfig(min: 20, max: 22, label: '초가을', category: 'warm'),
    TemperatureRangeConfig(min: 17, max: 19, label: '가을', category: 'mild'),
    TemperatureRangeConfig(min: 12, max: 16, label: '늦가을', category: 'cool'),
    TemperatureRangeConfig(min: 9, max: 11, label: '초겨울', category: 'chilly'),
    TemperatureRangeConfig(min: 5, max: 8, label: '겨울', category: 'cold'),
    TemperatureRangeConfig(min: -40, max: 4, label: '한겨울', category: 'extreme_cold'),
  ];
}

class TemperatureRangeConfig {
  final double min;
  final double max;
  final String label;
  final String category;

  const TemperatureRangeConfig({
    required this.min,
    required this.max,
    required this.label,
    required this.category,
  });
}
