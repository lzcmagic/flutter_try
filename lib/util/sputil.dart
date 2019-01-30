import 'package:shared_preferences/shared_preferences.dart';

class SPUtil{

  final String _kCATEGORIES='categories';
  final String _kCATEGORYIDS='category_ids';

  Future<bool> saveString(List<String> value) async{
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setStringList(_kCATEGORIES, value);
  }

  Future<bool> saveCategoryId(List<String> value) async{
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setStringList(_kCATEGORYIDS, value);
  }

  Future<List<String>> getCategories() async{
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    return  prefs.getStringList(_kCATEGORIES);
  }

  Future<List<String>> getCategoryIds() async{
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getStringList(_kCATEGORYIDS);
  }
}
