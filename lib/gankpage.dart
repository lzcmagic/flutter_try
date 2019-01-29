import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';

class GankPage extends StatefulWidget {
  @override
  _GankPageState createState() => _GankPageState();
}

class _GankPageState extends State<GankPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  List<Tab> _tabs = [
    Tab(text: 'aaa'),
    Tab(
      text: 'bbb',
    ),
    Tab(
      text: 'ccc',
    ),
    Tab(
      text: 'ddd',
    )
  ];

  Tab _selectedTab;

  int _currentIndex = 0;

  void _tapTab(int position) {
    print('$position');
  }

  void _handleTabSelection() {
    if (_currentIndex != _controller.index) {
      _currentIndex = _controller.index;
      _selectedTab = _tabs.elementAt(_controller.index);
      print(
          "Changed tab to: ${_selectedTab.toString().split('.').last} , index: ${_controller.index}");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _tabs.length);
    _controller.addListener(_handleTabSelection);
    GetApi().getGankInfo('all', 1).then((res) {
      print('gank init$res');
    }).catchError((err) {
      print('$err');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.removeListener(_handleTabSelection);
    super.dispose();
  }

  @override
  void didUpdateWidget(GankPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('gank didUpdateWidget');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('gank didChangeDependencies');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('gank deactivate');
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    print('gank reassemble');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 22.0),
          color: kSecondColor,
          child: TabBar(
            controller: _controller,
            tabs: _tabs,
            isScrollable: false,
//            onTap: _tapTab,
            indicatorColor: indicatorColor,
          ),
        ),
      ),
      body: new TabBarView(
        controller: _controller,
        dragStartBehavior: DragStartBehavior.start,
        children: _tabs.map((Tab tab) {
          return Center(
            child: Text(tab.text),
          );
        }).toList(),
      ),
    );
  }
}
