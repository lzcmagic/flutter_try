import 'package:flutter/material.dart';
import 'package:flutter_app/util/sqlutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'imagedetailpage.dart';

class CollectPicturePage extends StatefulWidget {
  @override
  _CollectPicturePageState createState() => _CollectPicturePageState();
}

class _CollectPicturePageState extends State<CollectPicturePage> {
  List<CollectDao> _collectPictures;

  void _getData() {
    MySql().queryDataByType(1).then((value) {
      setState(() {
        _collectPictures = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _collectPictures = List();
    _getData();
  }

  void _handleOnTap(String url) {
    var alertDialog = AlertDialog(
      title: Text('提示'),
      content: Text('取消收藏？'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              MySql().deleteData(url).then((res) {
                setState(() {
                  _getData();
                  Navigator.of(context).pop();
                });
              });
            },
            child: Text(
              '确定',
              style: TextStyle(color: Color(0xFF212121)),
            )),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('取消'),
          textColor: Colors.white70,
          color: Color(0xFF212121),
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  void _handleOnClick(String url) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        body: SizedBox.expand(
          child: ImageDetailPage(fromType: 1, imageUrl: url),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _collectPictures.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) => Card(
                    child: InkWell(
                  onTap: () {
                    _handleOnClick(_collectPictures[index].url);
                  },
                  onLongPress: () {
                    _handleOnTap(_collectPictures[index].url);
                  },
                  child: SafeArea(
                    child: Image(
                        fit: BoxFit.fitWidth,
                        image: CachedNetworkImageProvider(
                            _collectPictures[index].url)),
                  ),
                )),
            itemCount: _collectPictures.length,
          )
        : Center(
            child: Text('还没有收藏的内容...'),
          );
  }
}
