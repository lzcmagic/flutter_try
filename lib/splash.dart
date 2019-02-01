import 'package:flutter/material.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/xdcategory.dart';
import 'dart:convert';
import 'package:flutter_app/util/sputil.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState()=>_SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  void _countDown(){
    Future.delayed(Duration(seconds: 2),(){
      Navigator.of(context).pushReplacementNamed('home');
    });
  }

  @override
  void initState() {
    super.initState();
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
        _countDown();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('welcome'),
    );
  }
}
