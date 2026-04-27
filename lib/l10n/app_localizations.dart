import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ko'),
    Locale('en'),
  ];

  /// No description provided for @loadingLocation.
  ///
  /// In ko, this message translates to:
  /// **'위치를 가져오는 중...'**
  String get loadingLocation;

  /// No description provided for @loadingWeather.
  ///
  /// In ko, this message translates to:
  /// **'날씨를 불러오는 중...'**
  String get loadingWeather;

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @browserOpenFailed.
  ///
  /// In ko, this message translates to:
  /// **'브라우저를 열 수 없습니다.'**
  String get browserOpenFailed;

  /// No description provided for @feelsLike.
  ///
  /// In ko, this message translates to:
  /// **'체감 {temp}°'**
  String feelsLike(int temp);

  /// No description provided for @humidity.
  ///
  /// In ko, this message translates to:
  /// **'습도'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In ko, this message translates to:
  /// **'풍속'**
  String get windSpeed;

  /// No description provided for @precipitation.
  ///
  /// In ko, this message translates to:
  /// **'강수'**
  String get precipitation;

  /// No description provided for @timeSlotTitle.
  ///
  /// In ko, this message translates to:
  /// **'시간대별 옷차림'**
  String get timeSlotTitle;

  /// No description provided for @slotMorning.
  ///
  /// In ko, this message translates to:
  /// **'오전'**
  String get slotMorning;

  /// No description provided for @slotAfternoon.
  ///
  /// In ko, this message translates to:
  /// **'오후'**
  String get slotAfternoon;

  /// No description provided for @slotEvening.
  ///
  /// In ko, this message translates to:
  /// **'저녁'**
  String get slotEvening;

  /// No description provided for @outfitTitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 추천 옷차림'**
  String get outfitTitle;

  /// No description provided for @noRainToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 남은 시간 비 소식 없어요'**
  String get noRainToday;

  /// No description provided for @rainAt.
  ///
  /// In ko, this message translates to:
  /// **'{time}에 비가 와요'**
  String rainAt(String time);

  /// No description provided for @rainBetween.
  ///
  /// In ko, this message translates to:
  /// **'{start} ~ {end}에 비가 예상돼요'**
  String rainBetween(String start, String end);

  /// No description provided for @midnight.
  ///
  /// In ko, this message translates to:
  /// **'자정'**
  String get midnight;

  /// No description provided for @amHour.
  ///
  /// In ko, this message translates to:
  /// **'오전 {h}시'**
  String amHour(int h);

  /// No description provided for @pmNoon.
  ///
  /// In ko, this message translates to:
  /// **'오후 12시'**
  String get pmNoon;

  /// No description provided for @pmHour.
  ///
  /// In ko, this message translates to:
  /// **'오후 {h}시'**
  String pmHour(int h);

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @basicSettings.
  ///
  /// In ko, this message translates to:
  /// **'기본 설정'**
  String get basicSettings;

  /// No description provided for @tempUnit.
  ///
  /// In ko, this message translates to:
  /// **'온도 단위'**
  String get tempUnit;

  /// No description provided for @celsius.
  ///
  /// In ko, this message translates to:
  /// **'섭씨 (°C)'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In ko, this message translates to:
  /// **'화씨 (°F)'**
  String get fahrenheit;

  /// No description provided for @coldSensitivity.
  ///
  /// In ko, this message translates to:
  /// **'추위를 잘 타요'**
  String get coldSensitivity;

  /// No description provided for @coldSensitivityDesc.
  ///
  /// In ko, this message translates to:
  /// **'추천 기준을 3°C 낮게 적용합니다'**
  String get coldSensitivityDesc;

  /// No description provided for @appInfo.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get appInfo;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get version;

  /// No description provided for @wearScoreLabel.
  ///
  /// In ko, this message translates to:
  /// **'옷차림 지수 {score}'**
  String wearScoreLabel(int score);

  /// No description provided for @hotLabel.
  ///
  /// In ko, this message translates to:
  /// **'🥵 더움'**
  String get hotLabel;

  /// No description provided for @coldLabel.
  ///
  /// In ko, this message translates to:
  /// **'추움 🥶'**
  String get coldLabel;

  /// No description provided for @adviceExtremeHot.
  ///
  /// In ko, this message translates to:
  /// **'최대한 얇게 입으세요'**
  String get adviceExtremeHot;

  /// No description provided for @adviceHot.
  ///
  /// In ko, this message translates to:
  /// **'반팔·반바지면 충분해요'**
  String get adviceHot;

  /// No description provided for @adviceWarm.
  ///
  /// In ko, this message translates to:
  /// **'가볍게 입어도 돼요'**
  String get adviceWarm;

  /// No description provided for @adviceMild.
  ///
  /// In ko, this message translates to:
  /// **'가벼운 겉옷을 준비하세요'**
  String get adviceMild;

  /// No description provided for @adviceCool.
  ///
  /// In ko, this message translates to:
  /// **'겉옷을 꼭 챙기세요'**
  String get adviceCool;

  /// No description provided for @adviceChilly.
  ///
  /// In ko, this message translates to:
  /// **'두꺼운 겉옷이 필요해요'**
  String get adviceChilly;

  /// No description provided for @adviceCold.
  ///
  /// In ko, this message translates to:
  /// **'따뜻하게 입으세요'**
  String get adviceCold;

  /// No description provided for @adviceExtremeCold.
  ///
  /// In ko, this message translates to:
  /// **'최대한 두껍게 입으세요'**
  String get adviceExtremeCold;

  /// No description provided for @weatherDescExtremeHot.
  ///
  /// In ko, this message translates to:
  /// **'한여름 날씨예요'**
  String get weatherDescExtremeHot;

  /// No description provided for @weatherDescHot.
  ///
  /// In ko, this message translates to:
  /// **'여름 날씨예요'**
  String get weatherDescHot;

  /// No description provided for @weatherDescWarm.
  ///
  /// In ko, this message translates to:
  /// **'초가을 날씨예요'**
  String get weatherDescWarm;

  /// No description provided for @weatherDescMild.
  ///
  /// In ko, this message translates to:
  /// **'가을 날씨예요'**
  String get weatherDescMild;

  /// No description provided for @weatherDescCool.
  ///
  /// In ko, this message translates to:
  /// **'늦가을 날씨예요'**
  String get weatherDescCool;

  /// No description provided for @weatherDescChilly.
  ///
  /// In ko, this message translates to:
  /// **'초겨울 날씨예요'**
  String get weatherDescChilly;

  /// No description provided for @weatherDescCold.
  ///
  /// In ko, this message translates to:
  /// **'겨울 날씨예요'**
  String get weatherDescCold;

  /// No description provided for @weatherDescExtremeCold.
  ///
  /// In ko, this message translates to:
  /// **'한겨울 날씨예요'**
  String get weatherDescExtremeCold;

  /// No description provided for @bodyPartUpper.
  ///
  /// In ko, this message translates to:
  /// **'상의'**
  String get bodyPartUpper;

  /// No description provided for @bodyPartLower.
  ///
  /// In ko, this message translates to:
  /// **'하의'**
  String get bodyPartLower;

  /// No description provided for @bodyPartOuter.
  ///
  /// In ko, this message translates to:
  /// **'아우터'**
  String get bodyPartOuter;

  /// No description provided for @bodyPartShoes.
  ///
  /// In ko, this message translates to:
  /// **'신발'**
  String get bodyPartShoes;

  /// No description provided for @bodyPartAccessory.
  ///
  /// In ko, this message translates to:
  /// **'액세서리'**
  String get bodyPartAccessory;

  /// No description provided for @itemSleeveless.
  ///
  /// In ko, this message translates to:
  /// **'민소매/반팔'**
  String get itemSleeveless;

  /// No description provided for @itemTshirt.
  ///
  /// In ko, this message translates to:
  /// **'반팔/린넨셔츠'**
  String get itemTshirt;

  /// No description provided for @itemLongSleeve.
  ///
  /// In ko, this message translates to:
  /// **'긴팔/얇은 셔츠'**
  String get itemLongSleeve;

  /// No description provided for @itemSweatshirt.
  ///
  /// In ko, this message translates to:
  /// **'맨투맨/니트'**
  String get itemSweatshirt;

  /// No description provided for @itemFleeceSweatshirt.
  ///
  /// In ko, this message translates to:
  /// **'기모 맨투맨'**
  String get itemFleeceSweatshirt;

  /// No description provided for @itemShorts.
  ///
  /// In ko, this message translates to:
  /// **'반바지/치마'**
  String get itemShorts;

  /// No description provided for @itemCottonPants.
  ///
  /// In ko, this message translates to:
  /// **'면바지/반바지'**
  String get itemCottonPants;

  /// No description provided for @itemJeans.
  ///
  /// In ko, this message translates to:
  /// **'청바지/면바지'**
  String get itemJeans;

  /// No description provided for @itemFleecePants.
  ///
  /// In ko, this message translates to:
  /// **'기모 바지'**
  String get itemFleecePants;

  /// No description provided for @itemJeansOnly.
  ///
  /// In ko, this message translates to:
  /// **'청바지'**
  String get itemJeansOnly;

  /// No description provided for @itemSandals.
  ///
  /// In ko, this message translates to:
  /// **'샌들'**
  String get itemSandals;

  /// No description provided for @itemSneakers.
  ///
  /// In ko, this message translates to:
  /// **'스니커즈'**
  String get itemSneakers;

  /// No description provided for @itemLightCardigan.
  ///
  /// In ko, this message translates to:
  /// **'얇은 가디건'**
  String get itemLightCardigan;

  /// No description provided for @itemCardigan.
  ///
  /// In ko, this message translates to:
  /// **'가디건'**
  String get itemCardigan;

  /// No description provided for @itemKnit.
  ///
  /// In ko, this message translates to:
  /// **'니트/셔츠'**
  String get itemKnit;

  /// No description provided for @itemJacket.
  ///
  /// In ko, this message translates to:
  /// **'자켓/야상'**
  String get itemJacket;

  /// No description provided for @itemTrenchcoat.
  ///
  /// In ko, this message translates to:
  /// **'트렌치코트'**
  String get itemTrenchcoat;

  /// No description provided for @itemHeattech.
  ///
  /// In ko, this message translates to:
  /// **'히트텍 + 니트'**
  String get itemHeattech;

  /// No description provided for @itemHeavyHeattech.
  ///
  /// In ko, this message translates to:
  /// **'히트텍 + 두꺼운 니트'**
  String get itemHeavyHeattech;

  /// No description provided for @itemCoat.
  ///
  /// In ko, this message translates to:
  /// **'코트'**
  String get itemCoat;

  /// No description provided for @itemPadding.
  ///
  /// In ko, this message translates to:
  /// **'패딩/두꺼운 코트'**
  String get itemPadding;

  /// No description provided for @itemUmbrella.
  ///
  /// In ko, this message translates to:
  /// **'우산'**
  String get itemUmbrella;

  /// No description provided for @itemScarf.
  ///
  /// In ko, this message translates to:
  /// **'목도리'**
  String get itemScarf;

  /// No description provided for @itemWaterproofBoots.
  ///
  /// In ko, this message translates to:
  /// **'방수 부츠'**
  String get itemWaterproofBoots;

  /// No description provided for @itemWindbreaker.
  ///
  /// In ko, this message translates to:
  /// **'바람막이'**
  String get itemWindbreaker;

  /// No description provided for @itemScarfGloves.
  ///
  /// In ko, this message translates to:
  /// **'목도리 + 장갑'**
  String get itemScarfGloves;

  /// No description provided for @tipUmbrella.
  ///
  /// In ko, this message translates to:
  /// **'우산을 챙기세요!'**
  String get tipUmbrella;

  /// No description provided for @tipSnow.
  ///
  /// In ko, this message translates to:
  /// **'눈이 와요. 미끄럼 주의!'**
  String get tipSnow;

  /// No description provided for @tipWind.
  ///
  /// In ko, this message translates to:
  /// **'바람이 강해요.'**
  String get tipWind;

  /// No description provided for @tipHumidity.
  ///
  /// In ko, this message translates to:
  /// **'습도가 높아요. 통기성 좋은 소재를 추천해요.'**
  String get tipHumidity;

  /// No description provided for @tipExtremeHot.
  ///
  /// In ko, this message translates to:
  /// **'수분 보충 잊지 마세요!'**
  String get tipExtremeHot;

  /// No description provided for @tipHot.
  ///
  /// In ko, this message translates to:
  /// **'시원하게 입고 나가세요.'**
  String get tipHot;

  /// No description provided for @tipWarm.
  ///
  /// In ko, this message translates to:
  /// **'쌀쌀할 수 있으니 얇은 겉옷 챙기세요.'**
  String get tipWarm;

  /// No description provided for @tipMild.
  ///
  /// In ko, this message translates to:
  /// **'가볍게 걸칠 겉옷이 있으면 좋아요.'**
  String get tipMild;

  /// No description provided for @tipCool.
  ///
  /// In ko, this message translates to:
  /// **'자켓 하나 걸치세요.'**
  String get tipCool;

  /// No description provided for @tipChilly.
  ///
  /// In ko, this message translates to:
  /// **'따뜻하게 입고 나가세요.'**
  String get tipChilly;

  /// No description provided for @tipCold.
  ///
  /// In ko, this message translates to:
  /// **'두툼한 코트가 필요한 날씨예요.'**
  String get tipCold;

  /// No description provided for @tipExtremeCold.
  ///
  /// In ko, this message translates to:
  /// **'보온에 신경 쓰세요. 외출 시 목도리·장갑 필수!'**
  String get tipExtremeCold;

  /// No description provided for @stageExtremeCold.
  ///
  /// In ko, this message translates to:
  /// **'극한 추위'**
  String get stageExtremeCold;

  /// No description provided for @stageSevereCold.
  ///
  /// In ko, this message translates to:
  /// **'강추위'**
  String get stageSevereCold;

  /// No description provided for @stageChilly.
  ///
  /// In ko, this message translates to:
  /// **'쌀쌀'**
  String get stageChilly;

  /// No description provided for @stageCool.
  ///
  /// In ko, this message translates to:
  /// **'선선'**
  String get stageCool;

  /// No description provided for @stagePerfect.
  ///
  /// In ko, this message translates to:
  /// **'딱 좋음'**
  String get stagePerfect;

  /// No description provided for @stageWarm.
  ///
  /// In ko, this message translates to:
  /// **'따뜻'**
  String get stageWarm;

  /// No description provided for @stageHot.
  ///
  /// In ko, this message translates to:
  /// **'더움'**
  String get stageHot;

  /// No description provided for @stageExtremeHot.
  ///
  /// In ko, this message translates to:
  /// **'폭염'**
  String get stageExtremeHot;

  /// No description provided for @errGpsOff.
  ///
  /// In ko, this message translates to:
  /// **'위치 서비스(GPS)가 꺼져 있어요. 설정에서 켜주세요.'**
  String get errGpsOff;

  /// No description provided for @errLocationPermDenied.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 영구 거부되었어요. 설정 > 앱 > 권한에서 허용해 주세요.'**
  String get errLocationPermDenied;

  /// No description provided for @errLocationRequired.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 필요합니다.'**
  String get errLocationRequired;

  /// No description provided for @errLocationFetch.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 가져오지 못했어요: {error}'**
  String errLocationFetch(String error);

  /// No description provided for @errWeatherEmpty.
  ///
  /// In ko, this message translates to:
  /// **'현재 날씨 응답이 비어있습니다.'**
  String get errWeatherEmpty;

  /// No description provided for @errWeatherParse.
  ///
  /// In ko, this message translates to:
  /// **'현재 날씨 파싱 실패: {error}'**
  String errWeatherParse(String error);

  /// No description provided for @errNetworkSlow.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결이 지연되고 있습니다.'**
  String get errNetworkSlow;

  /// No description provided for @errApiKey.
  ///
  /// In ko, this message translates to:
  /// **'API 키가 유효하지 않습니다. (401)'**
  String get errApiKey;

  /// No description provided for @errNotFound.
  ///
  /// In ko, this message translates to:
  /// **'요청한 위치의 날씨 정보를 찾을 수 없습니다. (404)'**
  String get errNotFound;

  /// No description provided for @errRateLimit.
  ///
  /// In ko, this message translates to:
  /// **'API 호출 한도를 초과했습니다. 잠시 후 다시 시도해 주세요. (429)'**
  String get errRateLimit;

  /// No description provided for @errServerResponse.
  ///
  /// In ko, this message translates to:
  /// **'날씨 서버 응답 오류 ({status}).'**
  String errServerResponse(String status);

  /// No description provided for @errNoInternet.
  ///
  /// In ko, this message translates to:
  /// **'인터넷 연결을 확인해 주세요.'**
  String get errNoInternet;

  /// No description provided for @errRequestCancelled.
  ///
  /// In ko, this message translates to:
  /// **'요청이 취소되었습니다.'**
  String get errRequestCancelled;

  /// No description provided for @errUnknownNetwork.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 네트워크 오류가 발생했습니다.'**
  String get errUnknownNetwork;

  /// No description provided for @errForecastEmpty.
  ///
  /// In ko, this message translates to:
  /// **'예보 응답이 비어있습니다.'**
  String get errForecastEmpty;

  /// No description provided for @errForecastParse.
  ///
  /// In ko, this message translates to:
  /// **'예보 파싱 실패: {error}'**
  String errForecastParse(String error);

  /// No description provided for @errNetworkFailed.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 요청 실패'**
  String get errNetworkFailed;

  /// No description provided for @errCurrentWeather.
  ///
  /// In ko, this message translates to:
  /// **'현재 날씨 조회 중 오류가 발생했습니다.'**
  String get errCurrentWeather;

  /// No description provided for @errForecast.
  ///
  /// In ko, this message translates to:
  /// **'예보 조회 중 오류가 발생했습니다.'**
  String get errForecast;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
