import 'package:flutter/material.dart';
import 'package:flutter_app/util/sqlutil.dart';
import 'package:flutter_app/view/customRoute.dart';
import 'readdetailpage.dart';

class CollectArticlePage extends StatefulWidget {
  @override
  _CollectArticlePageState createState() => _CollectArticlePageState();
}

class _CollectArticlePageState extends State<CollectArticlePage> {
  List<CollectDao> _collectArticles;

  @override
  void initState() {
    super.initState();
    _collectArticles = List();
    MySql().queryDataByType(0).then((value) {
      setState(() {
        _collectArticles = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _collectArticles.length>0? ListView.builder(
      itemBuilder: (context, index) => Dismissible(
            key: ObjectKey(_collectArticles[index]),
            direction: DismissDirection.startToEnd,
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.startToEnd) {
                MySql().deleteData(_collectArticles[index].url);
              }
            },
            background: Container(
              color: Colors.red,
              child: const ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300],width: 1.0))),
              child: ListTile(
                title: Text(_collectArticles[index].title),
                trailing:
                    Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                onTap: () {
                  Navigator.of(context).push(CustomSlideRoute(
                      widget: ReadDetailPage(
                    htmlRaw: _collectArticles[index].url,
                    title: _collectArticles[index].title,
                  )));
                },
              ),
            ),
          ),
      itemCount: _collectArticles.length,
    ):Center(child: Text('还没有收藏的内容哦～'),);
  }
}
