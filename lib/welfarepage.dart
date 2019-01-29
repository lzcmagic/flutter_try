import 'package:flutter/material.dart';

class WelfarePage extends StatefulWidget{
  @override
  WelfarePageState createState() {
    return new WelfarePageState();
  }
}

class WelfarePageState extends State<WelfarePage> {

  @override
  void initState() {
    super.initState();
    print('welfare init');
  }

  @override
  void didUpdateWidget(WelfarePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('welfare didUpdateWidget');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('welfare didChangeDependencies');
  }


  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('welfare deactivate');
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    print('welfare reassemble');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text('welfare'),

    );
  }
}