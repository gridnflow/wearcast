// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loadingLocation => 'Getting your location...';

  @override
  String get loadingWeather => 'Loading weather...';

  @override
  String get retry => 'Retry';

  @override
  String get browserOpenFailed => 'Could not open browser.';

  @override
  String feelsLike(int temp) {
    return 'Feels like $temp°';
  }

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind';

  @override
  String get precipitation => 'Rain';

  @override
  String get timeSlotTitle => 'Outfit by time of day';

  @override
  String get slotMorning => 'Morning';

  @override
  String get slotAfternoon => 'Afternoon';

  @override
  String get slotEvening => 'Evening';

  @override
  String get outfitTitle => 'Today\'s Outfit';

  @override
  String get noRainToday => 'No rain expected today';

  @override
  String rainAt(String time) {
    return 'Rain expected at $time';
  }

  @override
  String rainBetween(String start, String end) {
    return 'Rain expected from $start to $end';
  }

  @override
  String get midnight => '12 AM';

  @override
  String amHour(int h) {
    return '$h AM';
  }

  @override
  String get pmNoon => '12 PM';

  @override
  String pmHour(int h) {
    return '$h PM';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get basicSettings => 'Preferences';

  @override
  String get tempUnit => 'Temperature Unit';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get coldSensitivity => 'Cold sensitive';

  @override
  String get coldSensitivityDesc =>
      'Applies a 3°C lower threshold for recommendations';

  @override
  String get appInfo => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get version => 'Version';

  @override
  String wearScoreLabel(int score) {
    return 'Wear Score $score';
  }

  @override
  String get hotLabel => '🥵 Hot';

  @override
  String get coldLabel => 'Cold 🥶';

  @override
  String get adviceExtremeHot => 'Dress as light as possible';

  @override
  String get adviceHot => 'A t-shirt and shorts will do';

  @override
  String get adviceWarm => 'Light clothing is fine';

  @override
  String get adviceMild => 'Bring a light jacket';

  @override
  String get adviceCool => 'Don\'t forget a jacket';

  @override
  String get adviceChilly => 'You\'ll need a thick jacket';

  @override
  String get adviceCold => 'Dress warmly';

  @override
  String get adviceExtremeCold => 'Layer up as much as possible';

  @override
  String get weatherDescExtremeHot => 'Peak summer';

  @override
  String get weatherDescHot => 'Summer';

  @override
  String get weatherDescWarm => 'Early fall';

  @override
  String get weatherDescMild => 'Fall';

  @override
  String get weatherDescCool => 'Late fall';

  @override
  String get weatherDescChilly => 'Early winter';

  @override
  String get weatherDescCold => 'Winter';

  @override
  String get weatherDescExtremeCold => 'Deep winter';

  @override
  String get bodyPartUpper => 'Top';

  @override
  String get bodyPartLower => 'Bottom';

  @override
  String get bodyPartOuter => 'Outer';

  @override
  String get bodyPartShoes => 'Shoes';

  @override
  String get bodyPartAccessory => 'Accessory';

  @override
  String get itemSleeveless => 'Sleeveless / T-Shirt';

  @override
  String get itemTshirt => 'T-Shirt / Linen Shirt';

  @override
  String get itemLongSleeve => 'Long Sleeve / Light Shirt';

  @override
  String get itemSweatshirt => 'Sweatshirt / Knit';

  @override
  String get itemFleeceSweatshirt => 'Fleece Sweatshirt';

  @override
  String get itemShorts => 'Shorts / Skirt';

  @override
  String get itemCottonPants => 'Cotton Pants / Shorts';

  @override
  String get itemJeans => 'Jeans / Cotton Pants';

  @override
  String get itemFleecePants => 'Fleece Pants';

  @override
  String get itemJeansOnly => 'Jeans';

  @override
  String get itemSandals => 'Sandals';

  @override
  String get itemSneakers => 'Sneakers';

  @override
  String get itemLightCardigan => 'Light Cardigan';

  @override
  String get itemCardigan => 'Cardigan';

  @override
  String get itemKnit => 'Knit / Shirt';

  @override
  String get itemJacket => 'Jacket';

  @override
  String get itemTrenchcoat => 'Trench Coat';

  @override
  String get itemHeattech => 'Thermal + Knit';

  @override
  String get itemHeavyHeattech => 'Thermal + Heavy Knit';

  @override
  String get itemCoat => 'Coat';

  @override
  String get itemPadding => 'Puffer / Heavy Coat';

  @override
  String get itemUmbrella => 'Umbrella';

  @override
  String get itemScarf => 'Scarf';

  @override
  String get itemWaterproofBoots => 'Waterproof Boots';

  @override
  String get itemWindbreaker => 'Windbreaker';

  @override
  String get itemScarfGloves => 'Scarf + Gloves';

  @override
  String get tipUmbrella => 'Bring an umbrella!';

  @override
  String get tipSnow => 'It\'s snowing — watch your step!';

  @override
  String get tipWind => 'It\'s windy outside.';

  @override
  String get tipHumidity => 'High humidity — breathable fabrics recommended.';

  @override
  String get tipExtremeHot => 'Stay hydrated!';

  @override
  String get tipHot => 'Dress light and stay cool.';

  @override
  String get tipWarm => 'Might get chilly — bring a light jacket.';

  @override
  String get tipMild => 'A light layer would be handy.';

  @override
  String get tipCool => 'Throw on a jacket.';

  @override
  String get tipChilly => 'Dress warmly.';

  @override
  String get tipCold => 'You\'ll need a thick coat today.';

  @override
  String get tipExtremeCold => 'Bundle up — scarf and gloves are a must!';

  @override
  String get stageExtremeCold => 'Extreme Cold';

  @override
  String get stageSevereCold => 'Very Cold';

  @override
  String get stageChilly => 'Chilly';

  @override
  String get stageCool => 'Cool';

  @override
  String get stagePerfect => 'Just Right';

  @override
  String get stageWarm => 'Warm';

  @override
  String get stageHot => 'Hot';

  @override
  String get stageExtremeHot => 'Extreme Heat';

  @override
  String get errGpsOff => 'GPS is off. Please enable it in Settings.';

  @override
  String get errLocationPermDenied =>
      'Location access permanently denied. Go to Settings > App > Permissions.';

  @override
  String get errLocationRequired => 'Location permission is required.';

  @override
  String errLocationFetch(String error) {
    return 'Could not get your location: $error';
  }

  @override
  String get errWeatherEmpty => 'Weather response is empty.';

  @override
  String errWeatherParse(String error) {
    return 'Failed to parse weather data: $error';
  }

  @override
  String get errNetworkSlow => 'Network connection is slow.';

  @override
  String get errApiKey => 'Invalid API key. (401)';

  @override
  String get errNotFound => 'Weather data not found for this location. (404)';

  @override
  String get errRateLimit =>
      'API rate limit exceeded. Please try again later. (429)';

  @override
  String errServerResponse(String status) {
    return 'Weather server error ($status).';
  }

  @override
  String get errNoInternet => 'Please check your internet connection.';

  @override
  String get errRequestCancelled => 'Request was cancelled.';

  @override
  String get errUnknownNetwork => 'An unknown network error occurred.';

  @override
  String get errForecastEmpty => 'Forecast response is empty.';

  @override
  String errForecastParse(String error) {
    return 'Failed to parse forecast: $error';
  }

  @override
  String get errNetworkFailed => 'Network request failed';

  @override
  String get errCurrentWeather => 'Error fetching current weather.';

  @override
  String get errForecast => 'Error fetching forecast.';
}
