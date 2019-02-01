class ReadModel {
  String id;
  String originId;
  String fingerprint;
  String title;
  bool unread;
  int crawled;
  int published;
  int engagement;
  OriginBean origin;
  SummaryBean summary;
  VisualBean visual;
  List<AlternateListBean> alternate;

  static ReadModel fromMap(Map<String, dynamic> map) {
    ReadModel temp = new ReadModel();
    temp.id = map['id'];
    temp.originId = map['originId'];
    temp.fingerprint = map['fingerprint'];
    temp.title = map['title'];
    temp.unread = map['unread'];
    temp.crawled = map['crawled'];
    temp.published = map['published'];
    temp.engagement = map['engagement'];
    temp.origin = OriginBean.fromMap(map['origin']);
    temp.summary = SummaryBean.fromMap(map['summary']);
    temp.visual = VisualBean.fromMap(map['visual']);
    temp.alternate = AlternateListBean.fromMapList(map['alternate']);
    return temp;
  }

  static List<ReadModel> fromMapList(dynamic mapList) {
    List<ReadModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

}

class OriginBean {
  String streamId;
  String title;
  String htmlUrl;

  static OriginBean fromMap(Map<String, dynamic> map) {
    OriginBean originBean = new OriginBean();
    originBean.streamId = map['streamId'];
    originBean.title = map['title'];
    originBean.htmlUrl = map['htmlUrl'];
    return originBean;
  }

  static List<OriginBean> fromMapList(dynamic mapList) {
    List<OriginBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class SummaryBean {
  String content;
  String direction;

  static SummaryBean fromMap(Map<String, dynamic> map) {
    SummaryBean summaryBean = new SummaryBean();
    summaryBean.content = map['content'];
    summaryBean.direction = map['direction'];
    return summaryBean;
  }

  static List<SummaryBean> fromMapList(dynamic mapList) {
    List<SummaryBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class VisualBean {
  String url;

  static VisualBean fromMap(Map<String, dynamic> map) {
    VisualBean visualBean = new VisualBean();
    visualBean.url = map['url'];
    return visualBean;
  }

  static List<VisualBean> fromMapList(dynamic mapList) {
    List<VisualBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class AlternateListBean {
  String href;
  String type;

  static AlternateListBean fromMap(Map<String, dynamic> map) {
    AlternateListBean alternateListBean = new AlternateListBean();
    alternateListBean.href = map['href'];
    alternateListBean.type = map['type'];
    return alternateListBean;
  }

  static List<AlternateListBean> fromMapList(dynamic mapList) {
    List<AlternateListBean> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}
