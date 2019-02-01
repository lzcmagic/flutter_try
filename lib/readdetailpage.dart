import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ReadDetailPage extends StatefulWidget {
  final String htmlRaw;
  final String title;

  const ReadDetailPage({Key key, this.htmlRaw, this.title}) : super(key: key);


  @override
  ReadDetailPageState createState() {
    return ReadDetailPageState();
  }
}

class ReadDetailPageState extends State<ReadDetailPage> {
  @override
  void initState() {
    super.initState();
    print(widget.htmlRaw);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebviewScaffold(
        url: widget.htmlRaw,
        appBar: AppBar(
          title: Text(widget.title),
        ),
      ),
    );
  }
}
