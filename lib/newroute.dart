import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class NewPage extends StatefulWidget{
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {

  static const platform=const MethodChannel('samples.flutter.io/battery');
  String _batteryLevel='Unknown battery level.';
  Future<Null> _getBatteryLevel() async{
    String batteryLevel;
    try{
      final int result =await platform.invokeMethod('getBatteryLevel');
      batteryLevel='Battery level at $result % .';
    }on PlatformException catch(e){
      batteryLevel="failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel=batteryLevel;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState');
  }

  @override
  void didUpdateWidget(NewPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('deactivate');
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    print('reassemble');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('didchangeDependencies');
  }


  @override
   Widget build(BuildContext context) {
    print('build');
    return new Scaffold(
      appBar: AppBar(
        title: Text('aaaa'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(_batteryLevel),
            RaisedButton(onPressed:  () async {
              Options options=new Options(
                baseUrl: 'http://gank.io/api/'
              );
                Dio dio=new Dio(options);
               Response response= await dio.get('day/2015/08/07');
               print(response.data.toString());
               _getBatteryLevel();
            })
          ],
        ),
      ),
    );
  }
}
