import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:wearcast/core/l10n/l10n.dart';
import 'package:wearcast/l10n/app_localizations.dart';

/// Runs once before the whole test suite. Domain/data layers read strings via
/// [L10n.current], which asserts an instance has been set (normally done in
/// MaterialApp.builder). Seed a Korean instance so context-free unit tests can
/// exercise code paths that produce localized text.
///
/// The delegate loads synchronously (SynchronousFuture), so no binding needs to
/// be initialized here — doing so would clash with the test binding that
/// `testWidgets` sets up for widget tests.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  L10n.setInstance(await AppLocalizations.delegate.load(const Locale('ko')));
  await testMain();
}
