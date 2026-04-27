import '../../l10n/app_localizations.dart';

/// Global accessor for [AppLocalizations].
///
/// Set once in [WearCastApp]'s MaterialApp.builder before any child widget
/// renders, so context-free layers (domain/data) can call L10n.current safely.
class L10n {
  L10n._();

  static AppLocalizations? _instance;

  static AppLocalizations get current {
    assert(_instance != null, 'L10n.setInstance() must be called in MaterialApp.builder');
    return _instance!;
  }

  static void setInstance(AppLocalizations l) => _instance = l;
}
