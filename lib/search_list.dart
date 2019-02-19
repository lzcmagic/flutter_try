import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'package:flutter_app/model/searchmodel.dart';
import 'package:flutter_app/readdetailpage.dart';
import 'package:flutter_app/view/customRoute.dart';

class SearchListPage extends StatefulWidget {
  final String keyWord;

  const SearchListPage({Key key,@required this.keyWord}) : super(key: key);

  @override
  _SearchListPageState createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  ScrollController _scrollController;
  List<SearchListBean> searchList = <SearchListBean>[];
  bool _canRefresh = true;
  int _page = 1;

  _handleScroll() {
    var position = _scrollController.position;
    if (position.pixels == position.maxScrollExtent && _canRefresh) {
      _page++;
      _getSearchData();
    }
  }

  _getSearchData() async {
    var res = await GetApi().getSearchDate(widget.keyWord, _page);
    SearchModel searchModel = SearchModel.fromMap(json.decode(res.toString()));
    if (searchModel.results.length < 10) {
      _canRefresh = false;
    } else {
      _canRefresh = true;
    }
    setState(() {
      searchList.addAll(searchModel.results);
    });
  }

  String _assembleTime(String date) {
    var dateTime = DateTime.parse(date);
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _getSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关键词：${widget.keyWord}'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == searchList.length) {
            return ListTile(
              title: Text(
                !_canRefresh? '已经到底了～' : '加载中...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(214, 137, 16, 1.0)),
              ),
            );
          } else {
            return ListTile(
              title: Text(searchList[index].desc == null
                  ? 'null'
                  : searchList[index].desc),
              subtitle: Text(searchList[index].publishedAt == null
                  ? 'null'
                  : _assembleTime(searchList[index].publishedAt)),
              onTap: () {
                Navigator.of(context).push(CustomSlideRoute(
                    widget: ReadDetailPage(
                  htmlRaw: searchList[index].url,
                  title: searchList[index].desc,
                )));
              },
            );
          }
        },
        itemCount: searchList.length > 0 ? searchList.length + 1 : 0,
      ),
    );
  }
}
