import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/settings/settings_repo.dart';
import 'package:my_love/src/components/settings/theme/theme.dart';

class ThemeBloc extends Bloc<ThemeEvent, AppTheme>{

  SettingsRepository repo = SR();
  
  AppTheme theme;

  ThemeBloc() : super(PURPLE_THEME){
    add(SettingsStarted());
  }

  @override
  Stream<AppTheme> mapEventToState(event) async* {
    if(event is SettingsStarted){
      await repo.initializePrefs();
      String settings = repo.getTheme();
      
        if(settings == PURPLE_THEME.name){
          theme = PURPLE_THEME;
        } else if(settings == YELLOW_THEME.name){
          theme = YELLOW_THEME;
        } else if(settings == BLUE_THEME.name){
          theme = BLUE_THEME;
        } else if(settings == GREEN_THEME.name){
          theme = GREEN_THEME;
        } else {
          theme = PURPLE_THEME;
          print('$settings is settings');
        }

     yield theme;
    }
    if(event is SetTheme){
      theme = event.theme;
      repo.setTheme(theme.name);
      yield theme;
    }
  }

}

class ThemeEvent{}

class SettingsStarted extends ThemeEvent{}

class SetTheme extends ThemeEvent{
  final AppTheme theme;
  SetTheme(this.theme) : assert(theme != null);
}