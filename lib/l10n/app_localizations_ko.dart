// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get loadingLocation => '위치를 가져오는 중...';

  @override
  String get loadingWeather => '날씨를 불러오는 중...';

  @override
  String get retry => '다시 시도';

  @override
  String get browserOpenFailed => '브라우저를 열 수 없습니다.';

  @override
  String feelsLike(int temp) {
    return '체감 $temp°';
  }

  @override
  String get humidity => '습도';

  @override
  String get windSpeed => '풍속';

  @override
  String get precipitation => '강수';

  @override
  String get timeSlotTitle => '시간대별 옷차림';

  @override
  String get slotMorning => '오전';

  @override
  String get slotAfternoon => '오후';

  @override
  String get slotEvening => '저녁';

  @override
  String get outfitTitle => '오늘의 추천 옷차림';

  @override
  String get noRainToday => '오늘 남은 시간 비 소식 없어요';

  @override
  String rainAt(String time) {
    return '$time에 비가 와요';
  }

  @override
  String rainBetween(String start, String end) {
    return '$start ~ $end에 비가 예상돼요';
  }

  @override
  String get midnight => '자정';

  @override
  String amHour(int h) {
    return '오전 $h시';
  }

  @override
  String get pmNoon => '오후 12시';

  @override
  String pmHour(int h) {
    return '오후 $h시';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get basicSettings => '기본 설정';

  @override
  String get tempUnit => '온도 단위';

  @override
  String get celsius => '섭씨 (°C)';

  @override
  String get fahrenheit => '화씨 (°F)';

  @override
  String get coldSensitivity => '추위를 잘 타요';

  @override
  String get coldSensitivityDesc => '추천 기준을 3°C 낮게 적용합니다';

  @override
  String get appInfo => '앱 정보';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get version => '버전';

  @override
  String wearScoreLabel(int score) {
    return '옷차림 지수 $score';
  }

  @override
  String get hotLabel => '🥵 더움';

  @override
  String get coldLabel => '추움 🥶';

  @override
  String get adviceExtremeHot => '최대한 얇게 입으세요';

  @override
  String get adviceHot => '반팔·반바지면 충분해요';

  @override
  String get adviceWarm => '가볍게 입어도 돼요';

  @override
  String get adviceMild => '가벼운 겉옷을 준비하세요';

  @override
  String get adviceCool => '겉옷을 꼭 챙기세요';

  @override
  String get adviceChilly => '두꺼운 겉옷이 필요해요';

  @override
  String get adviceCold => '따뜻하게 입으세요';

  @override
  String get adviceExtremeCold => '최대한 두껍게 입으세요';

  @override
  String get weatherDescExtremeHot => '한여름 날씨예요';

  @override
  String get weatherDescHot => '여름 날씨예요';

  @override
  String get weatherDescWarm => '초가을 날씨예요';

  @override
  String get weatherDescMild => '가을 날씨예요';

  @override
  String get weatherDescCool => '늦가을 날씨예요';

  @override
  String get weatherDescChilly => '초겨울 날씨예요';

  @override
  String get weatherDescCold => '겨울 날씨예요';

  @override
  String get weatherDescExtremeCold => '한겨울 날씨예요';

  @override
  String get bodyPartUpper => '상의';

  @override
  String get bodyPartLower => '하의';

  @override
  String get bodyPartOuter => '아우터';

  @override
  String get bodyPartShoes => '신발';

  @override
  String get bodyPartAccessory => '액세서리';

  @override
  String get itemSleeveless => '민소매/반팔';

  @override
  String get itemTshirt => '반팔/린넨셔츠';

  @override
  String get itemLongSleeve => '긴팔/얇은 셔츠';

  @override
  String get itemSweatshirt => '맨투맨/니트';

  @override
  String get itemFleeceSweatshirt => '기모 맨투맨';

  @override
  String get itemShorts => '반바지/치마';

  @override
  String get itemCottonPants => '면바지/반바지';

  @override
  String get itemJeans => '청바지/면바지';

  @override
  String get itemFleecePants => '기모 바지';

  @override
  String get itemJeansOnly => '청바지';

  @override
  String get itemSandals => '샌들';

  @override
  String get itemSneakers => '스니커즈';

  @override
  String get itemLightCardigan => '얇은 가디건';

  @override
  String get itemCardigan => '가디건';

  @override
  String get itemKnit => '니트/셔츠';

  @override
  String get itemJacket => '자켓/야상';

  @override
  String get itemTrenchcoat => '트렌치코트';

  @override
  String get itemHeattech => '히트텍 + 니트';

  @override
  String get itemHeavyHeattech => '히트텍 + 두꺼운 니트';

  @override
  String get itemCoat => '코트';

  @override
  String get itemPadding => '패딩/두꺼운 코트';

  @override
  String get itemUmbrella => '우산';

  @override
  String get itemScarf => '목도리';

  @override
  String get itemWaterproofBoots => '방수 부츠';

  @override
  String get itemWindbreaker => '바람막이';

  @override
  String get itemScarfGloves => '목도리 + 장갑';

  @override
  String get tipUmbrella => '우산을 챙기세요!';

  @override
  String get tipSnow => '눈이 와요. 미끄럼 주의!';

  @override
  String get tipWind => '바람이 강해요.';

  @override
  String get tipHumidity => '습도가 높아요. 통기성 좋은 소재를 추천해요.';

  @override
  String get tipExtremeHot => '수분 보충 잊지 마세요!';

  @override
  String get tipHot => '시원하게 입고 나가세요.';

  @override
  String get tipWarm => '쌀쌀할 수 있으니 얇은 겉옷 챙기세요.';

  @override
  String get tipMild => '가볍게 걸칠 겉옷이 있으면 좋아요.';

  @override
  String get tipCool => '자켓 하나 걸치세요.';

  @override
  String get tipChilly => '따뜻하게 입고 나가세요.';

  @override
  String get tipCold => '두툼한 코트가 필요한 날씨예요.';

  @override
  String get tipExtremeCold => '보온에 신경 쓰세요. 외출 시 목도리·장갑 필수!';

  @override
  String get stageExtremeCold => '극한 추위';

  @override
  String get stageSevereCold => '강추위';

  @override
  String get stageChilly => '쌀쌀';

  @override
  String get stageCool => '선선';

  @override
  String get stagePerfect => '딱 좋음';

  @override
  String get stageWarm => '따뜻';

  @override
  String get stageHot => '더움';

  @override
  String get stageExtremeHot => '폭염';

  @override
  String get errGpsOff => '위치 서비스(GPS)가 꺼져 있어요. 설정에서 켜주세요.';

  @override
  String get errLocationPermDenied =>
      '위치 권한이 영구 거부되었어요. 설정 > 앱 > 권한에서 허용해 주세요.';

  @override
  String get errLocationRequired => '위치 권한이 필요합니다.';

  @override
  String errLocationFetch(String error) {
    return '현재 위치를 가져오지 못했어요: $error';
  }

  @override
  String get errWeatherEmpty => '현재 날씨 응답이 비어있습니다.';

  @override
  String errWeatherParse(String error) {
    return '현재 날씨 파싱 실패: $error';
  }

  @override
  String get errNetworkSlow => '네트워크 연결이 지연되고 있습니다.';

  @override
  String get errApiKey => 'API 키가 유효하지 않습니다. (401)';

  @override
  String get errNotFound => '요청한 위치의 날씨 정보를 찾을 수 없습니다. (404)';

  @override
  String get errRateLimit => 'API 호출 한도를 초과했습니다. 잠시 후 다시 시도해 주세요. (429)';

  @override
  String errServerResponse(String status) {
    return '날씨 서버 응답 오류 ($status).';
  }

  @override
  String get errNoInternet => '인터넷 연결을 확인해 주세요.';

  @override
  String get errRequestCancelled => '요청이 취소되었습니다.';

  @override
  String get errUnknownNetwork => '알 수 없는 네트워크 오류가 발생했습니다.';

  @override
  String get errForecastEmpty => '예보 응답이 비어있습니다.';

  @override
  String errForecastParse(String error) {
    return '예보 파싱 실패: $error';
  }

  @override
  String get errNetworkFailed => '네트워크 요청 실패';

  @override
  String get errCurrentWeather => '현재 날씨 조회 중 오류가 발생했습니다.';

  @override
  String get errForecast => '예보 조회 중 오류가 발생했습니다.';
}
