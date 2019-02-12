class SearchModel {
  bool error;
  int count;
  List<SearchListBean> results;

  static SearchModel fromMap(Map<String, dynamic> map) {
    SearchModel temp = new SearchModel();
    temp.error = map['error'];
    temp.count = map['count'];
    temp.results = SearchListBean.fromMapList(map['results']);
    return temp;
  }

  static List<SearchModel> fromMapList(dynamic mapList) {
    List<SearchModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}

class SearchListBean {
  String desc;
  String ganhuo_id;
  String publishedAt;
  String readability;
  String type;
  String url;
  String who;

  static SearchListBean fromMap(Map<String, dynamic> map) {
    SearchListBean resultsListBean = new SearchListBean();
    resultsListBean.desc = map['desc'];
    resultsListBean.ganhuo_id = map['ganhuo_id'];
    resultsListBean.publishedAt = map['publishedAt'];
    resultsListBean.readability = map['readability'];
    resultsListBean.type = map['type'];
    resultsListBean.url = map['url'];
    resultsListBean.who = map['who'];
    return resultsListBean;
  }

  static List<SearchListBean> fromMapList(dynamic mapList) {
    List<SearchListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
