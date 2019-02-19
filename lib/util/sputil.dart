import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  final String _kCATEGORIES = 'categories';
  final String _kCATEGORYIDS = 'category_ids';
  final String _kHISTORY_SEARCH = 'history_search';

  Future<bool> saveString(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_kCATEGORIES, value);
    return prefs.commit();
  }

  Future<bool> saveCategoryId(List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_kCATEGORYIDS, value);
    return prefs.commit();
  }

  Future<List<String>> getCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kCATEGORIES);
  }

  Future<List<String>> getCategoryIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kCATEGORYIDS);
  }

  Future<bool> saveHistorySearch(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = await getHistorySearch();
    if (list == null) {
      list = <String>[];
    }

    var tempList = list.reversed.toList();
    if (tempList.last != value) {
      tempList.add(value);
    }

    if (tempList.length > 5) {
      tempList.removeAt(0);
    }
    prefs.setStringList(_kHISTORY_SEARCH, tempList.reversed.toList());
    return prefs.commit();
  }

  Future<List<String>> getHistorySearch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kHISTORY_SEARCH);
  }
}
