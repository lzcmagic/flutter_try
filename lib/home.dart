import 'package:flutter/material.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'gankpage.dart';
import 'xiandupage.dart';
import 'package:flutter_app/model/xdcategory.dart';
import 'dart:convert';
import 'package:flutter_app/util/sputil.dart';
import 'package:flutter_app/view/customRoute.dart';
import 'welfarepage.dart';
import 'package:flutter_app/config/myIcons.dart';

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
                icon: Icon(MyIcons.smile,color: Colors.white70,semanticLabel: 'Gank',),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                }),
            IconButton(
                icon: Icon(MyIcons.smile,color: Colors.white70,semanticLabel: '闲读',),
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