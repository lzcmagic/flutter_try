import 'package:flutter/material.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/xiandumodel.dart';
import 'dart:convert';
import 'readdetailpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/view/loading_view.dart';
import 'package:flutter_app/view/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app/view/customRoute.dart';

class XDDetailPage extends StatefulWidget {
  final String title;
  final String type;
  final String url;

  const XDDetailPage({Key key, this.title, this.type, this.url})
      : super(key: key);

  @override
  _XDDetailPageState createState() => _XDDetailPageState();
}

class _XDDetailPageState extends State<XDDetailPage> {
  int _currentPage = 1;

  List<XDListBean> xdLists = <XDListBean>[];
  ScrollController _scrollController;
  LoadingStatus _loadingStatus = LoadingStatus.idle;

  void getData() {
    GetApi().getXianduDetail(widget.type, _currentPage).then((res) {
      XDModel xdModel = XDModel.fromMap(json.decode(res.toString()));
      if (xdModel != null && !xdModel.error) {
        setState(() {
          _loadingStatus = LoadingStatus.success;
          xdLists.addAll(xdModel.results);
        });
      } else {
        setState(() {
          _loadingStatus = LoadingStatus.error;
        });
      }
    }).catchError((_) {
      setState(() {
        _loadingStatus = LoadingStatus.error;
      });
    });
  }

  void _handleScroll() {
    var position = _scrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      _currentPage++;
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadingStatus = LoadingStatus.loading;
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              widget.url,
              fit: BoxFit.fitWidth,
              width: 36.0,
            ),
            SizedBox(
              width: 16.0,
            ),
            Text(widget.title)
          ],
        ),
      ),
      body: Center(
        child: LoadingView(
            status: _loadingStatus,
            loadingContent: const PlatformAdaptiveProgressIndicator(),
            errorContent: Text("loading nothing~"),
            successContent: ListView.builder(
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) =>
                  _DetailItemPage(xdLists[index], widget.title),
              itemCount: xdLists.length,
            )),
      ),
    );
  }
}

class _DetailItemPage extends StatelessWidget {
  final XDListBean _xdListBean;
  final String _title;

  const _DetailItemPage(this._xdListBean, this._title);

  String _assembleTime() {
    var dateTime = DateTime.parse(_xdListBean.published_at);
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 142,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Colors.grey[400],
            width: 1.0,
          ))),
      padding: EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(CustomSlideRoute(
              widget: ReadDetailPage(
            htmlRaw: _xdListBean.url,
            title: _title,
          )));
//          Navigator.push(context,
//              MaterialPageRoute(builder: (BuildContext context) {
//            return ReadDetailPage(
//              htmlRaw: _xdListBean.url,
//              title: _title,
//            );
//          }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    _xdListBean.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(_assembleTime()),
//                  Align(
//                    alignment: Alignment.bottomLeft,
//                    child: ,
//                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Center(
              child: _xdListBean.cover != null && _xdListBean.cover.length > 5
                  ? Image(
                      image: CachedNetworkImageProvider(_xdListBean.cover,
                          scale: 5 / 3),
                      width: 140,
                      fit: BoxFit.fitWidth,
                    )
                  : SizedBox(
                      width: 1.0,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

//CachedNetworkImage(
//imageUrl: _xdListBean.cover,
//fit: BoxFit.contain,
//fadeInDuration: Duration(milliseconds: 200),
//fadeOutDuration: Duration(milliseconds: 200),
//width: 140.0,
//height: 120.0,
//)
