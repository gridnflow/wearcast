# Wearcast — 버그 및 에러 기록

> 발생한 순서대로 기록. 해결된 항목은 ✅, 미해결은 ❌.

---

## ✅ BUG-001 · 오전 배경이 야간(dark) 그라디언트로 표시됨
- **발생**: Phase 6 홈 화면 구현 직후
- **증상**: 오전(morning) 탭 선택 시 저녁/야간과 동일한 어두운 배경이 나옴
- **원인**: `_moodFrom()` 이 `DateTime.now().hour` 를 그대로 사용해 저녁 이후엔 항상 `night` 반환
- **해결**: 슬롯 인덱스로 참조 시각 고정 (slot 0→9시, 1→14시, 2→19시)하여 실제 현재 시각 대신 대표 시각을 사용

---

## ✅ BUG-002 · 시간대 탭 아이콘 배경색 변경 시도 후 UI 깨짐
- **발생**: 탭 아이콘을 배경색에 맞춰 변경하려다 발생
- **증상**: `WeatherMood.morning/afternoon/evening` enum 값이 존재하지 않아 컴파일 오류
- **원인**: 이전에 추가했던 enum 값들이 revert 되어 없어진 상태에서 참조
- **해결**: 작업 전체 revert 후 기존 enum 그대로 유지

---

## ✅ BUG-003 · 캐릭터 이미지가 이모지 서클로만 표시됨
- **발생**: Lottie JSON 캐릭터 파일 추가 후
- **증상**: `_CharacterBase` 가 Lottie JSON을 로드하려 했으나 파일 없어 fallback 이모지 표시
- **원인**: `stage_1.json~stage_8.json` 파일이 실제로 Lottie 애니메이션이 아닌 단순 JSON
- **해결**: Lottie 방식 폐기 → `Image.asset('assets/character/base/stage_$stage.png')` PNG 방식으로 교체

---

## ✅ BUG-004 · PNG 캐릭터 이미지에 흰 배경(체크무늬) 표시
- **발생**: Downloads에서 PNG 파일 복사 후
- **증상**: 캐릭터 주변에 흰색 또는 체크무늬 배경이 남아있음
- **원인**: 원본 PNG에 투명도(alpha) 미처리
- **해결**: Python Pillow flood-fill 스크립트로 4개 모서리부터 흰 배경 제거 후 알파 채널로 저장

---

## ✅ BUG-005 · `_buildAppBar` 에 인자 3개 전달 시 컴파일 오류
- **발생**: contentColor 시스템 추가 중
- **증상**: `_buildAppBar(context, weather.cityName, contentColor)` — parameter not defined
- **원인**: `_buildAppBar` 시그니처가 `(BuildContext, String)` 2개만 받음
- **해결**: `Color textColor` 세 번째 파라미터 추가

---

## ✅ BUG-006 · 연한 배경(sunny/cloudy)에서 텍스트 흰색으로 안 보임
- **발생**: Phase 6 UI 완성 후 실기기 테스트
- **증상**: 오전/오후 맑음 배경은 밝은데 텍스트가 흰색이라 가독성 없음
- **원인**: 모든 텍스트에 `AppColors.textOnDark` (흰색) 하드코딩
- **해결**: `WeatherMoodX.contentColor` / `isLight` getter 추가, `_WeatherBody.build()`에서 `mood.contentColor` 파생 후 모든 하위 위젯에 `textColor` 파라미터로 전달

---

## ✅ BUG-007 · `firebase_options.dart` 플레이스홀더 값으로 Firebase 초기화 실패 가능성
- **발생**: Phase 5 Firebase 연동 설정 후
- **증상**: `REPLACE_WITH_ANDROID_API_KEY` 등 TODO 값 그대로 남아있음
- **원인**: `flutterfire configure` 미실행
- **해결**: `google-services.json` 실제 값으로 Android 항목 수동 업데이트. iOS는 App Store 출시 시점에 추가 예정

---

## ❌ BUG-008 · iOS GoogleService-Info.plist 없음
- **발생**: 현재
- **증상**: iOS 빌드 시 Firebase 초기화 오류 가능성
- **원인**: Firebase 콘솔에서 iOS 앱 등록 및 plist 다운로드 미완료
- **해결 예정**: App Store 출시 전 Firebase 콘솔 > iOS 앱 추가 → `GoogleService-Info.plist` 다운로드 → `ios/Runner/` 에 추가

---

_마지막 업데이트: 2026-04-27_
