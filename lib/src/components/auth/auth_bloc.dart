import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_love/src/components/auth/auth_repo.dart';

// This class is used to interface with the auth repository. It logs the user in or out.
// This bloc is listened to by the root widget to determine whether to show the login page

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo = AuthRepository();
  String token;

  AuthBloc() : super(AuthStateUninitialized()) {
    startApp();
  }

  void startApp() async {
    await Future.delayed(Duration(seconds: 1));
    add(AppStarted());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if(event is LoggedIn){
      token = event.token;
      yield AuthStateAuthenticated();
    }
    if(event is LoggedOut){
      repo.signOut();
      yield AuthStateNotAuthenticated();
    }
    if(event is AppStarted){
      token = await repo.getCurrentUser();
      if(token != null){
        yield AuthStateAuthenticated();
      } else {
        yield AuthStateNotAuthenticated();
      }
    }
  }
}

//Authorization State - Bloc output
class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthStateNotAuthenticated extends AuthState {}

class AuthStateAuthenticated extends AuthState {}

class AuthStateUninitialized extends AuthState {}

class AuthStateLoading extends AuthState {}

//Authorization Event - Bloc Input
class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;
  const LoggedIn({this.token}) : assert(token != null);

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'Logged in {token: $token}';
}

class LoggedOut extends AuthEvent {}
