import 'package:flutter/material.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/xdcategory.dart';
import 'dart:convert';
import 'package:flutter_app/util/sputil.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  var ratioMargin = 0.0;

  void _countDown() {
    if (_controller != null) {
      _controller.forward();
    }
  }

  void initData() async {
    var response = await GetApi().getXianduCategories();
    XDCategory xdCategory =
        XDCategory.fromMap(json.decode(response.toString()));
    if (xdCategory != null && !xdCategory.error) {
      var results = xdCategory.results;
      List<String> strings = <String>[];
      List<String> stringsIds = <String>[];
      for (var i = 0; i < results.length; i++) {
        strings.add(results[i].name);
        stringsIds.add(results[i].en_name);
      }
      await SPUtil().saveString(strings);
      await SPUtil().saveCategoryId(stringsIds);
      _countDown();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacementNamed('home');
        }
      })
      ..addListener(() {
        setState(() {
          ratioMargin = animation.value;
        });
      });
    initData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: SizedBox(
          width: 180,
          child: Text(
            'welcome',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: ((width - 180) / 2.0) * ratioMargin),
      ),
    );
  }
}
