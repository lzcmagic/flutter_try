import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/util/sqlutil.dart';

class ReadDetailPage extends StatefulWidget {
  final String htmlRaw;
  final String title;

  const ReadDetailPage({Key key, this.htmlRaw, this.title}) : super(key: key);

  @override
  _ReadDetailPageState createState() => _ReadDetailPageState();
}

class _ReadDetailPageState extends State<ReadDetailPage> {
  IconData _iconData = Icons.favorite_border;

  /** 复制到剪粘板 */
  static copyToClipboard(final String text) {
    if (text == null) return;
    Clipboard.setData(new ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final snackbar = SnackBar(content: Text('复制成功！'));
    return Scaffold(
        body: Builder(
      builder: (context) => Container(
            child: WebviewScaffold(
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
                          setState(() {
                            MySql()
                                .insertData(widget.title, widget.htmlRaw, 0)
                                .then((dynamic) {
                              _iconData = Icons.favorite;
                            });
                          });
                        } else {
                          //取消
                          setState(() {
                            _iconData = Icons.favorite_border;
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
