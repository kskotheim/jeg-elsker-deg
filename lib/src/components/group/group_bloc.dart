import 'dart:math';

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
        String image = getRandomImage();
        //set it to shared prefs
        if(newNothing != null){
          await Future.wait([
            // new nothing
            _setTodaysNothing(newNothing.sweetNothing),
            _saveNothingUpdated(),
            _saveNothingId(newNothing.createdAt),
            // new image
            _setTodaysImage(image),
            _saveImageId(image),
          ]);
        }
      }
      yield ShowGroupInfo();
    }
    if(event is PreferencesButtonPushed){
      yield ShowGroupPreferences();
    }
  }

  String getRandomImage(){
    if(_imagesViewed().length >= images.length){  
      _resetImagesViewed();
    }
    List<String> unseenImages = images.where((element) => !_imagesViewed().contains(element)).toList();
    return unseenImages[Random().nextInt(unseenImages.length)];
  }


  String get NOTHING_UPDATED => 'Updated-$groupId-$currentUserId';
  String get TODAYS_NOTHING => 'Todays-$groupId-$currentUserId';
  String get NOTHINGS_VIEWED => 'Viewed-$groupId-$currentUserId';
  String get IMAGES_VIEWED => 'Images-Viewed-$groupId-$currentUserId';
  String get TODAYS_IMAGE => 'Todays-Image-$groupId-$currentUserId';
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

  Future<void> _setTodaysImage(String image){
    return sharedPrefs.setString(TODAYS_IMAGE, image);
  }

  String todaysNothing(){
    return sharedPrefs.getString(TODAYS_NOTHING);
  }

  String todaysImage(){
    return sharedPrefs.getString(TODAYS_IMAGE);
  }

  List<String> _nothingsViewed(){
    return sharedPrefs.getStringList(NOTHINGS_VIEWED) ?? [];
  }

  List<String> _imagesViewed(){
    return sharedPrefs.getStringList(IMAGES_VIEWED) ?? [];
  }

  Future<bool> resetNothingsViewed(){
    return sharedPrefs.setStringList(NOTHINGS_VIEWED, []);
  }

  Future<bool> _resetImagesViewed(){
    return sharedPrefs.setStringList(IMAGES_VIEWED, []);
  }
  
  Future<void> _saveNothingId(int createdAt){
    List<String> nothings = _nothingsViewed();
    if(!nothings.contains(createdAt.toString())){
      nothings.add(createdAt.toString());
    }
    return sharedPrefs.setStringList(NOTHINGS_VIEWED, nothings);
  }

  Future<void> _saveImageId(String image){
    List<String> images = _imagesViewed();
    if(!images.contains(image)){
      images.add(image);
    }
    return sharedPrefs.setStringList(IMAGES_VIEWED, images);
  }

  static const List<String> images = [
      'assets/img/backgrounds/amsterdam.jpg',
      'assets/img/backgrounds/dahlia.jpg',
      'assets/img/backgrounds/daisies.jpg',
      'assets/img/backgrounds/flowers.jpg',
      'assets/img/backgrounds/rijksmuseum.jpg',
      'assets/img/backgrounds/rose.jpg',
      'assets/img/backgrounds/wildflowers.jpg',

      'assets/img/backgrounds/birds_1.jpg',
      'assets/img/backgrounds/birds_2.jpg',
      'assets/img/backgrounds/birds_3.jpg',
      'assets/img/backgrounds/birds_4.jpg',
      'assets/img/backgrounds/birds_5.jpg',
      'assets/img/backgrounds/birds_6.jpg',
      'assets/img/backgrounds/birds_7.jpg',
      'assets/img/backgrounds/birds_8.jpg',
      'assets/img/backgrounds/birds_9.jpg',
      'assets/img/backgrounds/birds_10.jpg',
      'assets/img/backgrounds/birds_11.jpg',
      'assets/img/backgrounds/birds_12.jpg',
      'assets/img/backgrounds/birds_13.jpg',
      'assets/img/backgrounds/birds_14.jpg',
      'assets/img/backgrounds/birds_15.jpg',
      'assets/img/backgrounds/birds_16.jpg',
      'assets/img/backgrounds/birds_17.jpg',
      'assets/img/backgrounds/birds_18.jpg',
      'assets/img/backgrounds/birds_19.jpg',
      'assets/img/backgrounds/birds_20.jpg',
      'assets/img/backgrounds/birds_21.jpg',
      'assets/img/backgrounds/birds_22.jpg',
      'assets/img/backgrounds/birds_23.jpg',
      'assets/img/backgrounds/birds_24.jpg',
      'assets/img/backgrounds/birds_25.jpg',

      'assets/img/backgrounds/cats_1.jpg',
      'assets/img/backgrounds/cats_2.jpg',
      'assets/img/backgrounds/cats_3.jpg',
      'assets/img/backgrounds/cats_4.jpg',
      'assets/img/backgrounds/cats_5.jpg',

      'assets/img/backgrounds/elephant_1.jpg',

      'assets/img/backgrounds/flowers_1.jpg',
      'assets/img/backgrounds/flowers_2.jpg',
      'assets/img/backgrounds/flowers_3.jpg',
      'assets/img/backgrounds/flowers_4.jpg',
      'assets/img/backgrounds/flowers_5.jpg',
      'assets/img/backgrounds/flowers_6.jpg',
      'assets/img/backgrounds/flowers_7.jpg',
      'assets/img/backgrounds/flowers_8.jpg',
      'assets/img/backgrounds/flowers_9.jpg',
      'assets/img/backgrounds/flowers_10.jpg',
      'assets/img/backgrounds/flowers_11.jpg',
      'assets/img/backgrounds/flowers_12.jpg',
      'assets/img/backgrounds/flowers_13.jpg',
      'assets/img/backgrounds/flowers_14.jpg',
      'assets/img/backgrounds/flowers_15.jpg',

      'assets/img/backgrounds/giraffe_1.jpg',
      'assets/img/backgrounds/giraffe_2.jpg',
      'assets/img/backgrounds/giraffes_3.jpg',
      'assets/img/backgrounds/giraffes_4.jpg',
      'assets/img/backgrounds/giraffes_5.jpg',

      'assets/img/backgrounds/meerkats_1.jpg',
      'assets/img/backgrounds/meerkats_2.jpg',
      'assets/img/backgrounds/meerkats_3.jpg',

      'assets/img/backgrounds/monkeys_1.jpg',
      'assets/img/backgrounds/monkeys_2.jpg',
      'assets/img/backgrounds/monkeys_3.jpg',
      'assets/img/backgrounds/monkeys_4.jpg',
      'assets/img/backgrounds/monkeys_5.jpg',
      'assets/img/backgrounds/monkeys_6.jpg',
      
      'assets/img/backgrounds/moon_1.jpg',
      'assets/img/backgrounds/moon_2.jpg',
      'assets/img/backgrounds/moon_3.jpg',
      'assets/img/backgrounds/moon_4.jpg',
      'assets/img/backgrounds/moon_5.jpg',
      'assets/img/backgrounds/moon_6.jpg',
      'assets/img/backgrounds/moon_7.jpg',
      'assets/img/backgrounds/moon_8.jpg',

      'assets/img/backgrounds/turtles_1.jpg',
      'assets/img/backgrounds/turtles_2.jpg',
      'assets/img/backgrounds/turtles_3.jpg',

      'assets/img/backgrounds/whales_1.jpg',
      'assets/img/backgrounds/whales_2.jpg',
      'assets/img/backgrounds/whales_3.jpg',
      'assets/img/backgrounds/whales_4.jpg',

      'assets/img/backgrounds/wolves_1.jpg',
      'assets/img/backgrounds/wolves_2.jpg',




    ];
  
}

class GroupEvent {}

class GoToGroupHome extends GroupEvent {}

class PreferencesButtonPushed extends GroupEvent{}


class GroupState {}

class GroupStateLoading extends GroupState {}

class ShowGroupInfo extends GroupState {}

class ShowGroupPreferences extends GroupState {}
