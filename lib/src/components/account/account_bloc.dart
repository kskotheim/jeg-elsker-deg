import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_love/src/components/account/account_repo.dart';
import 'package:my_love/src/components/auth/user.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final String userId;
  User currentUser;

  AccountRepository accountRepo;

  AccountBloc({this.userId}) {
    assert(userId != null);
    accountRepo = AR(userId: userId);
    accountRepo.currentUser().listen((User user){
      if(user.userName == null){
        add(UserUnnamed());
      } else {
        currentUser = User(userId: userId, userName: user.userName);
        add(GoToAccountHome());
      }
    });
  }

  @override
  AccountState get initialState => AccountLoadingPage();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is RequestGroupConnection) {
      accountRepo.requestConnection(event.password, currentUser.userName);
    }
    if (event is GoToGroup) {
      yield ShowGroupPage(groupId: event.groupId);
    }
    if (event is GoToAccountHome) {
      yield ShowUserPage();
    }
    if(event is UserUnnamed){
      yield ShowRenameUserPage();
    }
    if (event is CreateGroup) {
      accountRepo.createGroup(event.groupName);
    }
    if(event is RenameUser){
      accountRepo.renameUser(event.userName);
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

class ShowRenameUserPage extends AccountState {}

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

class RequestGroupConnection extends AccountEvent {
  final String password;
  RequestGroupConnection({this.password}) : assert(password != null);
}

class CreateGroup extends AccountEvent {
  final String groupName;
  CreateGroup({this.groupName}) : assert(groupName != null);
}

class GoToGroup extends AccountEvent {
  final String groupId;
  const GoToGroup({this.groupId}) : assert(groupId != null);
}

class RenameUser extends AccountEvent {
  final String userName;
  RenameUser({this.userName}) : assert(userName != null);
}

class UserUnnamed extends AccountEvent {}

class GoToAccountHome extends AccountEvent {}
