import 'package:flutter/material.dart';
import 'collect_article.dart';
import 'collect_picture.dart';
import 'package:flutter_app/config/colors.dart';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;

  List<Widget> _tabWidgets = <Widget>[
    CollectArticlePage(),
    CollectPicturePage()
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('collect'),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              text: "article",
            ),
            Tab(
              text: 'picture',
            )
          ],
          isScrollable: false,
          controller: _controller,
          indicatorColor: indicatorColor,
        ),
      ),
      body: TabBarView(
        children: _tabWidgets,
        controller: _controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
