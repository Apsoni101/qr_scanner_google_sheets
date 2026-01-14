import 'package:flutter/widgets.dart';
import 'package:qr_scanner_practice/core/localisation/app_localizations.dart';

extension AppLocaleExtension on BuildContext {
  /// Access localized strings directly: context.locale.appName
  AppLocalizations get locale => AppLocalizations.of(this);
}
