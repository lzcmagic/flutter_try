import 'package:sqflite/sqflite.dart';
import 'dbutil.dart';

final String tableCollect = 'collect';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnUrl = 'url';
final String columnType = 'type';

class CollectDao {
  int id;
  String title;
  String url;
  int type;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnUrl: url,
      columnType: type
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  static CollectDao fromMap(Map<String, dynamic> map) {
    CollectDao collectDao = CollectDao();
    collectDao.id = map[columnId];
    collectDao.title = map[columnTitle];
    collectDao.url = map[columnUrl];
    collectDao.type = map[columnType];
    return collectDao;
  }

  static List<CollectDao> fromMapList(dynamic mapList) {
    List<CollectDao> list = List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }
}

class MySql {
  initDatabase() {}

  Future<int> insertData(String title, String url, int type) async {
    var db = await DBProvider.db.database;
    var insertId;
    await db.transaction((txn) async {
      insertId = txn.rawInsert(
          'insert into collect (title,url,type) values ("$title","$url","$type");');
    });
    return insertId;
  }

  Future<int> deleteData(String url) async {
    var db = await DBProvider.db.database;
    var deleteNum;
    await db.transaction((txn) async {
      deleteNum = txn.rawDelete('delete from collect where url = "$url"');
    });
    return deleteNum;
  }

  Future<CollectDao> queryDataByUrl(String url) async {
    var db = await DBProvider.db.database;
    var lists;
    await db.transaction((txn) async {
      lists = txn.query("collect",
          columns: [columnTitle, columnUrl, columnType],
          where: 'url=?',
          whereArgs: [url]);
    });
    List<CollectDao> collects;
    await lists.then((value) {
      collects = CollectDao.fromMapList(value);
    });
    if (collects.length > 0) {
      return collects.first;
    } else {
      return null;
    }
  }

  Future<List<CollectDao>> queryDataByType(int type) async {
    var db = await DBProvider.db.database;
    var queryList;
    await db.transaction((txn) async {
      queryList = txn.query("collect",
          columns: [columnId, columnTitle, columnUrl, columnType],
          where: 'type=?',
          whereArgs: [type]);
    });
    var fromMapList;
    await queryList.then((res){
      fromMapList= CollectDao.fromMapList(res);
    });
    return fromMapList;
  }

   closeDB() async {
    var db = await DBProvider.db.database;
    await db.close();
  }
}
