import '../../../../core/utils/result.dart';
import '../../../weather/domain/entities/weather.dart';
import '../entities/outfit.dart';
import '../repositories/outfit_repository.dart';

/// Parameters for [GetOutfitRecommendation].
class GetOutfitRecommendationParams {
  final Weather weather;
  final double sensitivity;

  const GetOutfitRecommendationParams({
    required this.weather,
    this.sensitivity = 0.0,
  });
}

/// Asks the outfit repository for a recommendation based on the current
/// weather and the user's temperature sensitivity.
class GetOutfitRecommendation {
  final OutfitRepository repository;

  const GetOutfitRecommendation(this.repository);

  Future<Result<Outfit>> call(GetOutfitRecommendationParams params) {
    return repository.recommend(
      weather: params.weather,
      sensitivity: params.sensitivity,
    );
  }
}
