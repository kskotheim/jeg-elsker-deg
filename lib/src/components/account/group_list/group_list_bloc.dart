import 'package:bloc/bloc.dart';
import 'package:my_love/src/components/account/account_repo.dart';
import 'package:my_love/src/components/account/group_list/group_info.dart';

class GroupListBloc extends Bloc<GroupListEvent, GroupListState> {
  final String userId;
  AccountRepository repo;

  GroupListBloc({this.userId}) {
    assert(userId != null);
    repo = AR(userId: userId);
    add(GetGroupList());
    repo.groupInfoStream().listen((List<GroupInfo> groupInfo) => add(NewGroupList(groupInfo: groupInfo)));
  }

  @override
  get initialState => GroupListLoading();

  @override
  Stream<GroupListState> mapEventToState(event) async* {
    if(event is NewGroupList){
      yield GroupList(groupInfo: event.groupInfo);
    }
    
  }
}

class GroupListEvent {}
class GetGroupList extends GroupListEvent {}
class NewGroupList extends GroupListEvent {
  List<GroupInfo> groupInfo;
  NewGroupList({this.groupInfo}) : assert(groupInfo != null);
}

class GroupListState {}

class GroupListLoading extends GroupListState {}

class GroupList extends GroupListState {
  final List<GroupInfo> groupInfo;

  GroupList({this.groupInfo = const <GroupInfo>[]});
}
