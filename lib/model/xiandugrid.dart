class XianduTitle {
  bool error;
  List<TitleListBean> results;

  static XianduTitle fromMap(Map<String, dynamic> map) {
    XianduTitle temp = new XianduTitle();
    temp.error = map['error'];
    temp.results = TitleListBean.fromMapList(map['results']);
    return temp;
  }

  static List<XianduTitle> fromMapList(dynamic mapList) {
    List<XianduTitle> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}

class TitleListBean {
  String _id;
  String created_at;
  String icon;
  String id;
  String title;

  static TitleListBean fromMap(Map<String, dynamic> map) {
    TitleListBean resultsListBean = new TitleListBean();
    resultsListBean._id = map['_id'];
    resultsListBean.created_at = map['created_at'];
    resultsListBean.icon = map['icon'];
    resultsListBean.id = map['id'];
    resultsListBean.title = map['title'];
    return resultsListBean;
  }

  static List<TitleListBean> fromMapList(dynamic mapList) {
    List<TitleListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
