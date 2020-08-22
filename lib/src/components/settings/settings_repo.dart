import 'package:my_love/src/data/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<void> initializePrefs();
  String getTheme();
  Future<void> setTheme(String theme);

  Stream<int> getPostCt(String userId);
  Stream<int> getPostUseCt(String userId);

}

class SR implements SettingsRepository {

  static const String _THEME_KEY = 'Theme';

  SharedPreferences _sharedPrefs;
  DatabaseManager db = DB.instance;
  
  Future<void> initializePrefs() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    return;
  }

  String getTheme(){
    return _sharedPrefs.getString(_THEME_KEY);
  }

  Future<void> setTheme(String theme){
    return _sharedPrefs.setString(_THEME_KEY, theme);
  } 

  Stream<int> getPostCt(String userId){
    return db.getPostCount(userId);
  }
  Stream<int> getPostUseCt(String userId){
    return db.getPostUseCount(userId);
  }
}