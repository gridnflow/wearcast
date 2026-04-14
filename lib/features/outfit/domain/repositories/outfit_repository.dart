import '../../../../core/utils/result.dart';
import '../../../weather/domain/entities/weather.dart';
import '../entities/outfit.dart';

/// Contract for producing outfit recommendations. Typically backed by a
/// local rule engine (no network dependency).
abstract class OutfitRepository {
  /// Recommend an outfit for [weather]. [sensitivity] is a user preference
  /// offset in degrees Celsius — positive values = user feels warmer than
  /// average (dress lighter), negative = user feels colder (dress heavier).
  Future<Result<Outfit>> recommend({
    required Weather weather,
    double sensitivity = 0.0,
  });
}
