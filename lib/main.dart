import 'package:flutter/material.dart';

import 'config/colors.dart';
import 'home.dart';
import 'splash.dart';

void main() => runApp(MyApp());

/// main enter
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _kDemoTheme,
      routes: {
        'home': (context) => MyHomePage(
              title: 'flutter_demo',
            )
      },
      home: SplashPage(),
    );
  }
}


final ThemeData _kDemoTheme = _buildCustomTheme();

ThemeData _buildCustomTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    accentColor: kColorAccent,
    primaryColor: kPrimary,
    buttonColor: kPrimary,
    bottomAppBarColor: kPrimary,
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: kColorAccent)),
    scaffoldBackgroundColor: kBackground,
//    cardColor: kShrineAltDarkGrey,
    textSelectionColor: kPrimary,
    errorColor: kError,
    textTheme: _buildShrineTextTheme(base.textTheme),
//    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(color: kPrimary),
//    inputDecorationTheme: InputDecorationTheme(
//      border: CutCornersBorder(),
//    ),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        displayColor: textColor,
        bodyColor: textColor,
      );
}
