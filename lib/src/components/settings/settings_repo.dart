import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<void> initializePrefs();
  String getTheme();
  Future<void> setTheme(String theme);

}

class SR implements SettingsRepository {

  static const String _THEME_KEY = 'Theme';

  SharedPreferences _sharedPrefs;
  
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
}