import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_string_base.dart';
import 'app_string_en.dart';
import 'app_string_zh.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static Map<dynamic, AppStringBase> _localizedValues = {
    'en': new AppStringEn(),
    'zh': new AppStringZh(),
  };

  AppStringBase get currentLocalized {
    if (_localizedValues.containsKey(locale.languageCode)) {
      return _localizedValues[locale.languageCode];
    }
    return _localizedValues["en"];
  }

  static AppStringBase i18n(BuildContext context) {
    return (Localizations.of(context, AppLocalizations) as AppLocalizations)
        .currentLocalized;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }
}
