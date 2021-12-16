import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_app/localization/app_localizations_delegate.dart';

class AppProvider extends ChangeNotifier {
  late int _platForm;

  Locale _locale = AppLocalizationsDelegate.delegate
      .defaultLocal; //Locale myLocale = Localizations.localeOf(context);

  int get platForm => _platForm;

  set platForm(int value) {
    _platForm = value;
  }

  Locale get locale => _locale;

  set locale(Locale value) {
    _locale = value;
  } //1 android/2 tv/3 ios

}
