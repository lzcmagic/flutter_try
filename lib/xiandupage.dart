import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/xiandugrid.dart';
import 'package:flutter_app/util/sputil.dart';
import 'package:flutter_app/view/loading_view.dart';
import 'package:flutter_app/view/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app/xiandudetailpage.dart';

import 'config/colors.dart';

class XianDuPage extends StatefulWidget {

  @override
  _XianDuPageState createState() =>_XianDuPageState();
}

class _XianDuPageState extends State<XianDuPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs = <Tab>[];
  TabController _tabController;
  List<DetailXianduPage> _details = <DetailXianduPage>[];

  void initTabs() async {
    var categories = await SPUtil().getCategories();
    var categoryIds = await SPUtil().getCategoryIds();
    if (categoryIds != null && categoryIds.length > 0 && categories != null) {
      List<Tab> tabs = <Tab>[];
      List<DetailXianduPage> details = <DetailXianduPage>[];
      for (int i = 0; i < categories.length; i++) {
        tabs.add(Tab(
          text: categories[i],
        ));
        details.add(DetailXianduPage(
          type: categoryIds[i],
        ));
      }
      setState(() {
        _details = details;
        _tabs = tabs;
        _tabController = TabController(vsync: this, length: _tabs.length);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
    initTabs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('闲读'),
        actions: <Widget>[
          PopupMenuButton<XianduBehavior>(
            onSelected: (XianduBehavior value) {
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuItem<XianduBehavior>>[
              const PopupMenuItem<XianduBehavior>(
                  value: XianduBehavior.collect,
                  child: Text(
                    'collect',
                    style: TextStyle(color: Colors.white70),
                  )),
              const PopupMenuItem<XianduBehavior>(
                  value: XianduBehavior.settings,
                  child: Text(
                    'settings',
                    style: TextStyle(color: Colors.white70),
                  )),
            ],
          ),
        ],
        bottom: TabBar(tabs: _tabs,
        isScrollable: true,
        indicatorColor: indicatorColor,
        controller: _tabController,),
      ),
//      appBar: PreferredSize(
//        preferredSize: Size.fromHeight(kToolbarHeight),
//        child: Container(
//          padding: EdgeInsets.only(top: 28.0),
//          color: kSecondColor,
//          child: TabBar(
//            tabs: _tabs,
//            controller: _tabController,
//            isScrollable: true,
//            indicatorColor: indicatorColor,
//          ),
//        ),
//      ),
      body: new TabBarView(
        controller: _tabController,
        children: _details,
      ),
    );
  }
}

class DetailXianduPage extends StatefulWidget {
  final String type;

  const DetailXianduPage({Key key, this.type}) : super(key: key);

  @override
  _DetailXianduPageState createState() =>_DetailXianduPageState();
}

class _DetailXianduPageState extends State<DetailXianduPage>
    with AutomaticKeepAliveClientMixin {
  List<TitleListBean> _listTitles = <TitleListBean>[];
  LoadingStatus _loadingStatus = LoadingStatus.idle;

  @override
  void initState() {
    super.initState();
    GetApi().getXianduWithCategory(widget.type).then((res) {
      var xianduTitle = XianduTitle.fromMap(json.decode(res.toString()));
      if (xianduTitle != null && xianduTitle.results.length > 0) {
        setState(() {
          _loadingStatus = LoadingStatus.success;
          _listTitles = xianduTitle.results;
        });
      }
    }).catchError((err) {
      _loadingStatus = LoadingStatus.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadingView(
        status: _loadingStatus,
        loadingContent: const PlatformAdaptiveProgressIndicator(),
        errorContent: Text('error~~ nothing to show'),
        successContent: Container(
          padding: EdgeInsets.all(12.0),
          child: GridView.count(
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            crossAxisCount: 2,
            children: List.generate(_listTitles.length, (index) {
              return Card(
                elevation: 10.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => XDDetailPage(
                                  title: _listTitles[index].title,
                                  type: _listTitles[index].id,
                                  url: _listTitles[index].icon,
                                )));
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border: Border(
                              top:
                                  BorderSide(color: indicatorColor, width: 2.0),
                              left:
                                  BorderSide(color: indicatorColor, width: 2.0),
                              bottom:
                                  BorderSide(color: indicatorColor, width: 2.0),
                              right:
                                  BorderSide(color: indicatorColor, width: 2.0),
                            )),
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Image.network(
                              _listTitles[index].icon,
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.medium,
                            )),
                      ),
                      Center(
                        child: Text(
                          _listTitles[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: kPrimary,
                              shadows: [
                                Shadow(
                                    color: kPrimary,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 5.0)
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum XianduBehavior{
  collect,
  settings
}