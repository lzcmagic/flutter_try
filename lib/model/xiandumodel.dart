class XDModel {
  bool error;
  List<XDListBean> results;

  static XDModel fromMap(Map<String, dynamic> map) {
    XDModel temp = new XDModel();
    temp.error = map['error'];
    temp.results = XDListBean.fromMapList(map['results']);
    return temp;
  }

  static List<XDModel> fromMapList(dynamic mapList) {
    List<XDModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}

class XDListBean {
  String _id;
  String content;
  String cover;
  String created_at;
  String published_at;
  String raw;
  String title;
  String uid;
  String url;
  bool deleted;
  int crawled;
  SiteBean site;

  static XDListBean fromMap(Map<String, dynamic> map) {
    XDListBean resultsListBean = new XDListBean();
    resultsListBean._id = map['_id'];
    resultsListBean.content = map['content'];
    resultsListBean.cover = map['cover'];
    resultsListBean.created_at = map['created_at'];
    resultsListBean.published_at = map['published_at'];
    resultsListBean.raw = map['raw'];
    resultsListBean.title = map['title'];
    resultsListBean.uid = map['uid'];
    resultsListBean.url = map['url'];
    resultsListBean.deleted = map['deleted'];
    resultsListBean.crawled = map['crawled'];
    resultsListBean.site = SiteBean.fromMap(map['site']);
    return resultsListBean;
  }

  static List<XDListBean> fromMapList(dynamic mapList) {
    List<XDListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class SiteBean {
  String cat_cn;
  String cat_en;
  String desc;
  String feed_id;
  String icon;
  String id;
  String name;
  String type;
  String url;
  int subscribers;

  static SiteBean fromMap(Map<String, dynamic> map) {
    SiteBean siteBean = new SiteBean();
    siteBean.cat_cn = map['cat_cn'];
    siteBean.cat_en = map['cat_en'];
    siteBean.desc = map['desc'];
    siteBean.feed_id = map['feed_id'];
    siteBean.icon = map['icon'];
    siteBean.id = map['id'];
    siteBean.name = map['name'];
    siteBean.type = map['type'];
    siteBean.url = map['url'];
    siteBean.subscribers = map['subscribers'];
    return siteBean;
  }

  static List<SiteBean> fromMapList(dynamic mapList) {
    List<SiteBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}