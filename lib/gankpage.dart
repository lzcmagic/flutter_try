import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/gankmodel.dart';
import 'dart:convert';
import 'package:flutter_app/view/loading_view.dart';
import 'package:flutter_app/view/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app/view/tipwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'readdetailpage.dart';

class GankPage extends StatefulWidget {
  @override
  _GankPageState createState() => _GankPageState();
}

class _GankPageState extends State<GankPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;

  static List<Tab> _tabs = [
    Tab(
      text: 'all',
    ),
    Tab(
      text: 'android',
    ),
    Tab(
      text: 'ios',
    ),
    Tab(
      text: 'web',
    )
  ];

  List<DetailPage> _detailPages = [
    DetailPage('all'),
    DetailPage('Android'),
    DetailPage('iOS'),
    DetailPage('前端'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          padding: EdgeInsets.only(top: 28.0),
          color: kSecondColor,
          child: TabBar(
            controller: _controller,
            tabs: _tabs,
            isScrollable: false,
            indicatorColor: indicatorColor,
          ),
        ),
      ),
      body: new TabBarView(
        controller: _controller,
        dragStartBehavior: DragStartBehavior.down,
        children: _detailPages,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DetailPage extends StatefulWidget {
  final String _type;

  const DetailPage(this._type);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with AutomaticKeepAliveClientMixin {
  List<ResultsListBean> resultBeans = <ResultsListBean>[];
  int currentPage = 1;
  LoadingStatus _loadingStatus = LoadingStatus.loading;
  ScrollController _scrollController;

  void _handleScroll() {
    var position = _scrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      currentPage++;
      getData();
    }
  }

  void getData() {
    GetApi().getGankInfo(widget._type, currentPage).then((res) {
      var decode = json.decode(res.toString());
      GKModel gkModels = GKModel.fromMap(decode);
      if (!gkModels.error) {
        setState(() {
          _loadingStatus = LoadingStatus.success;
          resultBeans.addAll(gkModels.results);
        });
      } else {
        setState(() {
          _loadingStatus = LoadingStatus.error;
        });
      }
    }).catchError((err) {
      setState(() {
        _loadingStatus = LoadingStatus.error;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    getData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadingView(
        status: _loadingStatus,
        loadingContent: const PlatformAdaptiveProgressIndicator(),
        errorContent: Text('error~~ nothing to show'),
        successContent: ListView.builder(
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) =>
              GankDetailItem(resultsListBean: resultBeans != null ? resultBeans[index] : null,),
          itemCount: resultBeans != null ? resultBeans.length : 0,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class GankDetailItem extends StatelessWidget {
  final ResultsListBean resultsListBean;

  const GankDetailItem({Key key, this.resultsListBean}) : super(key: key);

  String _assembleTime() {
    var dateTime = DateTime.parse(resultsListBean.publishedAt);
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            ReadDetailPage(htmlRaw: resultsListBean.url,title: 'gank',)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                  color: Colors.grey[400],
                  width: 1.0,
                ))),
        padding: EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(resultsListBean.desc),
            resultsListBean.images != null
                ? CachedNetworkImage(
              imageUrl: resultsListBean.images[0],
              fit: BoxFit.fitWidth,
              height: 70,
              fadeOutDuration: Duration(milliseconds: 200),
              fadeInDuration: Duration(milliseconds: 200),
            )
                : SizedBox(
              height: 1,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('author: ' + resultsListBean.who),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TipWidget(resultsListBean.type),
                  Text(
                    _assembleTime(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

