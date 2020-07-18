import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_love/src/components/account/account_repo.dart';
import 'package:my_love/src/components/auth/user.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final String userId;
  User currentUser;
  bool isPro = false;

  AccountRepository accountRepo;

  AccountBloc({this.userId}) {
    assert(userId != null);
    accountRepo = AR(userId: userId);
    _getUserAndListenToGroups();
  }

  void _getUserAndListenToGroups() async {
    currentUser = await accountRepo.getCurrentUser();

    //TODO: check whether user has upgraded to pro
    

    //check whether user is connected to a group yet
    accountRepo.groupInfoStream().listen((List<GroupInfo> groups){
      if(groups.isEmpty){
        //if not, show the connection page
        add(GoToAccountHome());
      }
      else {
        //if they are, show the group page
        add(GoToGroup(groupId: groups[0].groupId));
      }
    });
  }

  @override
  AccountState get initialState => AccountLoadingPage();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is AttemptConnection) {
      if(event.password != currentUser.password){
        accountRepo.createGroup(event.password);
      }
    }
    if (event is GoToGroup) {
      yield ShowGroupPage(groupId: event.groupId);
    }
    if (event is GoToAccountHome) {
      yield ShowUserPage();
    }

  }

  
}

//Account States

class AccountState extends Equatable {
  const AccountState();
  @override
  List<Object> get props => [];
}

class ShowUserPage extends AccountState {}

class ShowGroupPage extends AccountState {
  final String groupId;
  const ShowGroupPage({this.groupId}) : assert(groupId != null);

  @override
  List<Object> get props => [groupId];
}

class AccountLoadingPage extends AccountState {}

// Account Events

class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AttemptConnection extends AccountEvent {
  final String password;
  AttemptConnection({this.password}) : assert(password != null);
}

class GoToGroup extends AccountEvent {
  final String groupId;
  const GoToGroup({this.groupId}) : assert(groupId != null);
}

class GoToAccountHome extends AccountEvent {}
