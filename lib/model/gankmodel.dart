class GKModel {
  bool error;
  List<ResultsListBean> results;

  static GKModel fromMap(Map<String, dynamic> map) {
    GKModel temp = new GKModel();
    temp.error = map['error'];
    temp.results = ResultsListBean.fromMapList(map['results']);
    return temp;
  }

  static List<GKModel> fromMapList(dynamic mapList) {
    List<GKModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}

class ResultsListBean {
  String _id;
  String createdAt;
  String desc;
  String publishedAt;
  String source;
  String type;
  String url;
  String who;
  bool used;
  List<String> images;

  static ResultsListBean fromMap(Map<String, dynamic> map) {
    ResultsListBean resultsListBean = new ResultsListBean();
    resultsListBean._id = map['_id'];
    resultsListBean.createdAt = map['createdAt'];
    resultsListBean.desc = map['desc'];
    resultsListBean.publishedAt = map['publishedAt'];
    resultsListBean.source = map['source'];
    resultsListBean.type = map['type'];
    resultsListBean.url = map['url'];
    resultsListBean.who = map['who'];
    resultsListBean.used = map['used'];

    List<dynamic> dynamicList0 = map['images'];
    if(dynamicList0!=null){
      resultsListBean.images = new List();
      resultsListBean.images.addAll(dynamicList0.map((o) => o.toString()));
    }
    return resultsListBean;
  }

  static List<ResultsListBean> fromMapList(dynamic mapList) {
    List<ResultsListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
