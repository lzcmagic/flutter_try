import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'config/colors.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/gankmodel.dart';
import 'dart:convert';
import 'package:flutter_app/view/loading_view.dart';
import 'package:flutter_app/view/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app/view/tipwidget.dart';

class GankPage extends StatefulWidget {
  @override
  _GankPageState createState() => _GankPageState();
}

class _GankPageState extends State<GankPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;

  static List<Tab> _tabs = [
    Tab(text: 'all'),
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
    print(resultBeans.length);
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
              GankDetailItem(resultBeans != null ? resultBeans[index] : null),
          itemCount: resultBeans != null ? resultBeans.length : 0,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class GankDetailItem extends StatefulWidget {
  final ResultsListBean _resultsListBean;

  const GankDetailItem(this._resultsListBean);

  @override
  _GankDetailItemState createState() => _GankDetailItemState();
}

class _GankDetailItemState extends State<GankDetailItem> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        print(widget._resultsListBean.desc);
      },
      child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget._resultsListBean.desc),
                widget._resultsListBean.images!=null?
                AspectRatio(aspectRatio: 4/3,
                  child: Image.network(widget._resultsListBean.images[0],
                  height: 70,
                  fit: BoxFit.fitWidth,),
                ):SizedBox(height: 1,),
                SizedBox(height: 10.0,),
                Text('author: '+widget._resultsListBean.who),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TipWidget(widget._resultsListBean.type),

                      Text(widget._resultsListBean.publishedAt,maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
