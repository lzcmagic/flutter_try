import 'package:flutter/material.dart';
import 'newroute.dart';
import 'gankpage.dart';
import 'welfarepage.dart';
import 'xiandupage.dart';
import 'mine.dart';
import 'config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/util/sputil.dart';
import 'dart:convert';
import 'package:flutter_app/model/xdcategory.dart';

void main() => runApp(MyApp());

/// main enter
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _kDemoTheme,
      routes: {'newPage': (context) => NewPage()},
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.description), title: Text('gank')),
    BottomNavigationBarItem(icon: Icon(Icons.image), title: Text('welfare')),
    BottomNavigationBarItem(icon: Icon(Icons.receipt), title: Text('relax')),
    BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('mine')),
  ];

  final _widgetOptions = [
    GankPage(),
    WelfarePage(),
    XianDuPage(),
    MinePage(),
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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomItems,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
////          Navigator.pushNamed(context, 'newPage');
//          Navigator.push(context, new MaterialPageRoute(builder: (context) {
//            return new NewPage();
//          }));
//        },
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
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
//    fontFamily: 'Rubik',
        displayColor: kColorAccent,
        bodyColor: kColorAccent,
      );
}
