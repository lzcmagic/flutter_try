import 'package:sqflite/sqflite.dart';
import 'dbutil.dart';

final String tableCollect = 'collect';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnUrl = 'url';
final String columnType ='type';
class CollectDao{

  int id;
  String title;
  String url;
  int type;

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
        columnTitle:title,
      columnUrl:url,
      columnType:type
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }


  static CollectDao fromMap(Map<String,dynamic> map){
    CollectDao collectDao=CollectDao();
    collectDao.id=map[columnId];
    collectDao.title=map[columnTitle];
    collectDao.url=map[columnUrl];
    collectDao.type=map[columnType];
    return collectDao;
  }

  static List<CollectDao> fromMapList(dynamic mapList){
    List<CollectDao> list=List(mapList.length);
    for(int i=0;i<mapList.length;i++){
      list[i]=fromMap(mapList[i]);
    }
    return list;
  }

}

class MySql {
  initDatabase() {}

  Future<bool> insertData(String title,String url,int type) async {
    var db = await DBProvider.db.database;
    await db.transaction((txn) async{
      var insertId = txn.rawInsert('insert into collect (title,url,type) values ($title,$url,$type);');
      return true;
    });
    return false;
  }

  Future deleteData(var id) async {
    var db = await DBProvider.db.database;
    await db.transaction((txn) async {
      var deleteNum = txn.rawDelete('delete from collect where id = $id');
      print('deleteNum : $deleteNum');
    });
  }

  Future queryDataByType(int type) async {
    var db = await DBProvider.db.database;
    await db.transaction((txn) async {
      var dataList = txn.rawQuery('select * from collect where type = $type');
      print('dataList : $dataList');
    });
  }

  Future closeDB() async {
    var db = await DBProvider.db.database;
    await db.close();
  }
}
