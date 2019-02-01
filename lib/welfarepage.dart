import 'package:flutter/material.dart';
import 'package:flutter_app/config/colors.dart';
import 'package:flutter_app/view/loading_view.dart';
import 'package:flutter_app/http/gethttp.dart';
import 'dart:convert';
import 'package:flutter_app/model/gankmodel.dart';
import 'package:flutter_app/view/platform_adaptive_progress_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WelfarePage extends StatefulWidget {
  @override
  _WelfarePageState createState() => _WelfarePageState();
}

class _WelfarePageState extends State<WelfarePage> {
  LoadingStatus _loadingStatus = LoadingStatus.idle;
  int currentPage = 1;
  List<ResultsListBean> _results = <ResultsListBean>[];
  ScrollController _scrollController;

  void getData() {
    GetApi().getGankInfo('福利', currentPage).then((res) {
      GKModel gkModel = GKModel.fromMap(json.decode(res.toString()));
      if (gkModel != null && gkModel.results.length > 0) {
        setState(() {
          _loadingStatus = LoadingStatus.success;
          _results.addAll(gkModel.results);
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

  void _handleScroll() {
    var position = _scrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      currentPage++;
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _loadingStatus = LoadingStatus.loading;
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
          title: Text(
            'welfare',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: LoadingView(
            status: _loadingStatus,
            loadingContent: const PlatformAdaptiveProgressIndicator(),
            errorContent: Text('loadding error ~~'),
            successContent: GridView.builder(
                controller: _scrollController,
                itemCount: _results.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,childAspectRatio: 3/5),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: AspectRatio(
                      aspectRatio: 3 / 5,
                      child: Image(
                          fit: BoxFit.fitHeight,
                          image: CachedNetworkImageProvider(_results[index].url,
                              scale: 3 / 5, errorListener: () {
                            return Icon(Icons.error);
                          })),
                    ),
                  );
                }),
          ),
        ));
  }
}
