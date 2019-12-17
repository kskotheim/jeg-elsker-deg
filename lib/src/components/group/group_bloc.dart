import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/group/group.dart';
import 'package:my_love/src/components/group/group_repo.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final String groupId;
  String password;

  GroupRepository repo;

  GroupBloc({this.groupId}) {
    assert(groupId != null);
     repo = GR(groupId: groupId);

    repo.getGroup().listen((group) => add(GroupInfoUpdated(group: group)));
  }

  @override
  GroupState get initialState => GroupStateLoading();

  @override
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    if(event is GroupInfoUpdated){
      password = event.group.password;
      yield ShowGroupInfo(group: event.group);
    }
  }
}

class GroupEvent {}

class GroupInfoUpdated extends GroupEvent{
  final Group group;
  GroupInfoUpdated({this.group}) : assert(group != null);
}

class GroupState {}

class GroupStateLoading extends GroupState{}

class ShowGroupInfo extends GroupState{
  final Group group;

  ShowGroupInfo({this.group}) : assert(group != null);

}
