import 'package:flutter/material.dart';
import 'config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/view/loading_view.dart';
import 'package:flutter_app/model/xdcategory.dart';
import 'package:flutter_app/model/xiandumodel.dart';
import 'package:flutter_app/model/xiandugrid.dart';
import 'dart:convert';
import 'package:flutter_app/util/sputil.dart';
import 'package:flutter_app/config/colors.dart';
import 'package:flutter_app/view/platform_adaptive_progress_indicator.dart';

class XianDuPage extends StatefulWidget {
  @override
  XianDuPageState createState() {
    return new XianDuPageState();
  }
}

class XianDuPageState extends State<XianDuPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs = <Tab>[];
  TabController _tabController;
  List<DetailXianduPage> _details = <DetailXianduPage>[];

  void initTabs() async {
    var categories = await SPUtil().getCategories();
    var categoryIds = await SPUtil().getCategoryIds();
    print(categories);
    if (categoryIds != null && categoryIds.length > 0) {
      setState(() {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 22.0),
          color: kSecondColor,
          child: TabBar(
            tabs: _tabs,
            controller: _tabController,
            isScrollable: true,
            indicatorColor: indicatorColor,
          ),
        ),
      ),
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
  DetailXianduPageState createState() {
    return DetailXianduPageState();
  }
}

class DetailXianduPageState extends State<DetailXianduPage>
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
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          border: Border(
                            top: BorderSide(color: indicatorColor, width: 2.0),
                            left: BorderSide(color: indicatorColor, width: 2.0),
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
