import 'package:flutter/material.dart';
import 'package:flutter_app/view/customRoute.dart';

import 'config/colors.dart';
import 'gankpage.dart';
import 'splash.dart';
import 'welfarepage.dart';
import 'xiandupage.dart';
import 'config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/util/sputil.dart';
import 'dart:convert';
import 'package:flutter_app/model/xdcategory.dart';
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final _widgetOptions = [
    GankPage(),
    XianDuPage(),
  ];

  @override
  void initState() {
    GetApi().getXianduCategories().then((res) {
      XDCategory category = XDCategory.fromMap(json.decode(res.toString()));
      if (category != null && !category.error) {
        var results = category.results;
        List<String> strings = <String>[];
        List<String> stringsIds = <String>[];
        for (var i = 0; i < results.length; i++) {
          strings.add(results[i].name);
          stringsIds.add(results[i].en_name);
        }
        SPUtil().saveString(strings);
        SPUtil().saveCategoryId(stringsIds);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.description),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                }),
            IconButton(
                icon: Icon(Icons.receipt),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(CustomFadeRoute(widget: WelfarePage()));
        },
        child: Icon(Icons.camera,semanticLabel: 'welfare',color: Colors.white70,),
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
