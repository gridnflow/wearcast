import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../weather/domain/entities/weather.dart';
import '../../domain/entities/outfit.dart';
import '../../domain/usecases/calculate_wear_score.dart';
import '../../domain/usecases/recommend_outfit.dart';

final calculateWearScoreProvider = Provider<CalculateWearScore>((ref) {
  return const CalculateWearScore();
});

final recommendOutfitProvider = Provider<RecommendOutfit>((ref) {
  final scorer = ref.watch(calculateWearScoreProvider);
  return RecommendOutfit(scoreCalculator: scorer);
});

final outfitForWeatherProvider =
    Provider.family<Outfit, Weather>((ref, weather) {
  final recommender = ref.watch(recommendOutfitProvider);
  final sensitivity = ref.watch(settingsProvider).sensitivityOffset;
  return recommender(weather, sensitivity: sensitivity);
});
