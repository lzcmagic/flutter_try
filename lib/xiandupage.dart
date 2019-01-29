import 'package:flutter/material.dart';
import 'config/colors.dart';

class XianDuPage extends StatefulWidget {
  @override
  XianDuPageState createState() {
    return new XianDuPageState();
  }
}

class XianDuPageState extends State<XianDuPage> {
  List<Tab> _tabs = [
    Tab(
      text: 'aaa',
    ),
    Tab(
      text: 'bbb',
    ),
    Tab(
      text: 'ccc',
    ),
    Tab(
      text: 'ddd',
    ),
    Tab(
      text: 'ddd',
    ),
    Tab(
      text: 'ddd',
    ),
    Tab(
      text: 'ddd',
    )
  ];

  @override
  void initState() {
    super.initState();
//    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: kSecondColor,
            child: TabBar(
              tabs: _tabs,
              isScrollable: true,
              indicatorColor: indicatorColor,
            ),
          ),
        ),
        body: new TabBarView(
          children: _tabs.map((Tab tab) {
            return Center(
              child: Text(tab.text),
            );
          }).toList(),
        ),
      ),
    );
  }
}
