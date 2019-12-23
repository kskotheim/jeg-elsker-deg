import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/components/group/group_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final String groupId;
  final String currentUserId;
  Group currentGroup;

  GroupRepository repo;
  SharedPreferences sharedPrefs;

  GroupBloc({this.groupId, this.currentUserId}) {
    assert(groupId != null, currentUserId != null);
    repo = GR(groupId: groupId);
    _getSharedPrefs();
    repo.getGroup().listen((group) {
      currentGroup = group;
      if(sharedPrefs != null){
        add(GoToGroupHome());
      }
    });
  }

  void _getSharedPrefs() async {
    sharedPrefs = await SharedPreferences.getInstance();

    if(currentGroup != null){
      add(GoToGroupHome());
    }
  }

  @override
  GroupState get initialState => GroupStateLoading();

  @override
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    
    if (event is GoToGroupHome) {
      if(_isNewDay()){
        // get a new nothing
        SweetNothing newNothing = await repo.getRandomSweetNothing(currentUserId, _nothingsViewed(), resetNothingsViewed);
        //set it to shared prefs
        if(newNothing != null){
          await Future.wait([
            _setTodaysNothing(newNothing.sweetNothing),
            _saveNothingUpdated(),
            _saveNothingId(newNothing.createdAt)
          ]);
        }
      }
      yield ShowGroupInfo();
    }
    if(event is PreferencesButtonPushed){
      yield ShowGroupPreferences();
    }
  }


  String get NOTHING_UPDATED => 'Updated-$groupId';
  String get TODAYS_NOTHING => 'Todays-$groupId';
  String get NOTHINGS_VIEWED => 'Viewed-$groupId';
  String dayToString(DateTime dateTime) => '${dateTime.month} - ${dateTime.day} - ${dateTime.year}';
  
  Future<void> _saveNothingUpdated(){
    return sharedPrefs.setString(NOTHING_UPDATED, dayToString(DateTime.now()));
  }

  bool _isNewDay(){
    return dayToString(DateTime.now()).compareTo(sharedPrefs.getString(NOTHING_UPDATED) ?? '') != 0;
  }

  Future<void> _setTodaysNothing(String nothing){
    return sharedPrefs.setString(TODAYS_NOTHING, nothing);
  }

  String todaysNothing(){
    return sharedPrefs.getString(TODAYS_NOTHING);
  }

  List<String> _nothingsViewed(){
    return sharedPrefs.getStringList(NOTHINGS_VIEWED) ?? [];
  }

  Future<bool> resetNothingsViewed(){
    return sharedPrefs.setStringList(NOTHINGS_VIEWED, []);
  }
  
  Future<void> _saveNothingId(int createdAt){
    List<String> nothings = _nothingsViewed();
    if(!nothings.contains(createdAt.toString())){
      nothings.add(createdAt.toString());
    }
    return sharedPrefs.setStringList(NOTHINGS_VIEWED, nothings);
  }
}

class GroupEvent {}

class GoToGroupHome extends GroupEvent {}

class PreferencesButtonPushed extends GroupEvent{}


class GroupState {}

class GroupStateLoading extends GroupState {}

class ShowGroupInfo extends GroupState {}

class ShowGroupPreferences extends GroupState {}
