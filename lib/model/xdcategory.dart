class XDCategory {
  bool error;
  List<CategoryListBean> results;

  static XDCategory fromMap(Map<String, dynamic> map) {
    XDCategory temp = new XDCategory();
    if (map != null) {
      temp.error = map['error'];
      temp.results = CategoryListBean.fromMapList(map['results']);
    }
    return temp;
  }

  static List<XDCategory> fromMapList(dynamic mapList) {
    List<XDCategory> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class CategoryListBean {
  String _id;
  String en_name;
  String name;
  int rank;

  static CategoryListBean fromMap(Map<String, dynamic> map) {
    CategoryListBean resultsListBean = new CategoryListBean();
    resultsListBean._id = map['_id'];
    resultsListBean.en_name = map['en_name'];
    resultsListBean.name = map['name'];
    resultsListBean.rank = map['rank'];
    return resultsListBean;
  }

  static List<CategoryListBean> fromMapList(dynamic mapList) {
    List<CategoryListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
