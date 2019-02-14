import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/util/sqlutil.dart';
import 'package:flutter_app/config/colors.dart';

class ReadDetailPage extends StatefulWidget {
  final String htmlRaw;
  final String title;

  const ReadDetailPage({Key key, this.htmlRaw, this.title}) : super(key: key);

  @override
  _ReadDetailPageState createState() => _ReadDetailPageState();
}

class _ReadDetailPageState extends State<ReadDetailPage> {
  IconData _iconData = Icons.favorite_border;

  @override
  void initState() {
    super.initState();
    MySql().queryDataByUrl(widget.htmlRaw).then((dao) {
      if (dao != null) {
        setState(() {
          _iconData = Icons.favorite;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final snackbar = SnackBar(content: Text('复制成功！'));
    return Scaffold(
        body: Builder(
      builder: (context) => Container(
            child: WebviewScaffold(
              allowFileURLs: true,
              url: widget.htmlRaw,
              appBar: AppBar(
                title: Text(widget.title),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        _iconData,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        if (_iconData == Icons.favorite_border) {
                          //收藏
                          MySql()
                              .insertData(widget.title, widget.htmlRaw, 0)
                              .then((num) {
                            setState(() {
                              _iconData = Icons.favorite;
                            });
                          });
                        } else {
                          //取消
                          MySql().deleteData(widget.htmlRaw).then((num) {
                            if (num > 0) {
                              setState(() {
                                _iconData = Icons.favorite_border;
                              });
                            }
                          });
                        }
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.content_copy,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        //复制链接
                        Clipboard.setData(ClipboardData(text: widget.htmlRaw));
                        Scaffold.of(context).showSnackBar(snackbar);
                      })
                ],
              ),
            ),
          ),
    ));
  }
}
