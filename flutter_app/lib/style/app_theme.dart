// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

///颜色
class AppColors {
  static const int primaryIntValue = 0xff267aff;

  static const MaterialColor primarySwatch = const MaterialColor(
    primaryIntValue,
    const <int, Color>{
      50: const Color(primaryIntValue),
      100: const Color(primaryIntValue),
      200: const Color(primaryIntValue),
      300: const Color(primaryIntValue),
      400: const Color(primaryIntValue),
      500: const Color(primaryIntValue),
      600: const Color(primaryIntValue),
      700: const Color(primaryIntValue),
      800: const Color(primaryIntValue),
      900: const Color(primaryIntValue),
    },
  );

  static const primaryValueString = "#24292E";
  static const primaryLightValueString = "#42464b";
  static const primaryDarkValueString = "#121917";
  static const miWhiteString = "#ececec";
  static const actionBlueString = "#267aff";
  static const webDraculaBackgroundColorString = "#282a36";

  //主色
  static const Color primaryValue = Color(0xff267aff);
  static const Color primaryLightValue = Color(0xff267aff);
  static const Color primaryDarkValue = Color(0xff267aff);

  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color miWhite = Color(0xffececec);
  static const Color white = Color(0xFFFFFFFF);
  static const Color actionBlue = Color(0xff267aff);
  static const Color activeBlue = Color(0xff267aff);
  static const Color subTextColor = Color(0xff959595);
  static const Color subLightTextColor = Color(0xffc4c4c4);

  static const Color grey = Color(0xFF3A5160);
  static const Color mainBackgroundColor = miWhite;

  static const Color mainTextColor = primaryDarkValue;
  static const Color textColorWhite = white;

  static const Color nearlyBlack = Color(0xFF213333);
  static const Color darkText = Color(0xFF253840);
  static const Color divider = Color(0xffeeeeee);
  static const Color selected = Color(0xff267aff);
  static const Color page = Color(0xfff1f1f1);
}

class AppConstant {
  static const lagerTextSize = 30.0;
  static const bigTextSize = 23.0;
  static const normalTextSize = 17.0;
  static const middleTextWhiteSize = 15.0;
  static const smallTextSize = 13.0;
  static const minTextSize = 11.0;
  static const fontName = 'WorkSans';
  static const heroCourseItem = "heroCourseItem";
  static const heroCreateCourseCover = "heroCreateCourseCover";

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: AppColors.darkText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: AppColors.darkText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: AppColors.darkText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: AppColors.darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: AppColors.darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: AppColors.darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: AppColors.darkText, // was lightText
  );
}

class AppICons {
  static const DEFAULT_APP_LOGO = 'static/images/ic_logo_app.png';
  static const DEFAULT_IMAGE = 'static/images/user_image.png';
  static const DEFAULT_USER_DEFAULT_HEAD = 'static/images/user_image.png';
}
