import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/gankmodel.dart';
import 'package:flutter_app/model/searchmodel.dart';
import 'dart:convert';
import 'package:flutter_app/view/loading_view.dart';
import 'package:flutter_app/view/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app/view/tipwidget.dart';
import 'package:flutter_app/view/customRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'readdetailpage.dart';
import 'package:flutter_app/util/sputil.dart';

class GankPage extends StatefulWidget {
  @override
  _GankPageState createState() => _GankPageState();
}

class _GankPageState extends State<GankPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  final _GankSearchDelegate _delegate = _GankSearchDelegate();
  String _lastSelectStr = '';

  static List<Tab> _tabs = [
    Tab(text: 'all'),
    Tab(text: 'android'),
    Tab(text: 'ios'),
    Tab(text: 'web')
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
      appBar: AppBar(
        title: Text('gank'),
        bottom: TabBar(
          tabs: _tabs,
          isScrollable: false,
          controller: _controller,
          indicatorColor: indicatorColor,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String selectStr =
                  await showSearch(context: context, delegate: _delegate);
              if (selectStr != null && selectStr != _lastSelectStr) {
                setState(() {
                  _lastSelectStr = selectStr;
                });
              }
            },
          ),
          PopupMenuButton<GankBehavior>(
            onSelected: (GankBehavior value) {},
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<GankBehavior>>[
                  const PopupMenuItem<GankBehavior>(
                      value: GankBehavior.collect,
                      child: Text(
                        'collect',
                        style: TextStyle(color: Colors.white70),
                      )),
                  const PopupMenuItem<GankBehavior>(
                      value: GankBehavior.settings,
                      child: Text(
                        'settings',
                        style: TextStyle(color: Colors.white70),
                      )),
                ],
          ),
        ],
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
          itemBuilder: (BuildContext context, int index) => GankDetailItem(
                resultsListBean:
                    resultBeans != null ? resultBeans[index] : null,
              ),
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
        Navigator.of(context).push(CustomSlideRoute(
            widget: ReadDetailPage(
          htmlRaw: resultsListBean.url,
          title: 'gank',
        )));
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
            resultsListBean.images != null && resultsListBean.images.length > 0
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

class _GankSearchDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: kPrimary,
      primaryColorBrightness: Brightness.dark,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white70),
      textTheme: theme.textTheme
          .copyWith()
          .apply(bodyColor: Colors.white70, displayColor: Colors.white70),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? SizedBox()
          : IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        tooltip: 'Back',
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  List<SearchListBean> searchList;

  @override
  void showResults(BuildContext context) async {
    searchList = <SearchListBean>[];
    var res = await GetApi().getSearchDate(query, 1);
    SearchModel searchModel = SearchModel.fromMap(json.decode(res.toString()));
    searchList.addAll(searchModel.results);
    await SPUtil().saveHistorySearch(query);
    super.showResults(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: searchList != null && searchList.length > 0
          ? ListView.builder(
              itemBuilder: (context, index) => ListTile(
                    title: Text(searchList[index].desc == null
                            ? 'null'
                            : searchList[index].desc),
                    onTap: () {},
                  ),
              itemCount:  searchList.length,
            )
          : Center(
              child: Text('nothing to show ~~'),
            ),
    );
  }

  List<String> _history = <String>[];

  @override
  void showSuggestions(BuildContext context) async {
    _history.clear();
    var list = await SPUtil().getHistorySearch();
    _history.addAll(list);
    super.showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: const Icon(
            Icons.history,
            color: Colors.grey,
          ),
          title: Text(_history[index]),
          onTap: () {
            query = _history[index];
            showResults(context);
          },
        );
      },
      itemCount: _history.length,
    );
  }
}

enum GankBehavior { collect, settings }
