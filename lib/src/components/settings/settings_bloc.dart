import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/settings/settings_repo.dart';
import 'package:my_love/src/components/settings/theme.dart';

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
      switch(settings){
        case 'Purple':
          theme = PURPLE_THEME;
          break;
        case 'Blue':
          theme = BLUE_THEME;
          break;
        default:
          theme = PURPLE_THEME;
          break;
      }
     yield theme;
    }
    if(event is SetTheme){
      theme = event.theme;
    }
  }

}

class ThemeEvent{}

class SettingsStarted extends ThemeEvent{}

class SetTheme extends ThemeEvent{
  final AppTheme theme;
  SetTheme(this.theme) : assert(theme != null);
}