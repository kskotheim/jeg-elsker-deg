import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/auth/auth_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo = AuthRepository();
  final AuthBloc authBloc;

  LoginBloc({this.authBloc})
      : assert(authBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final String token = await repo.signInWithEmailAndPassword(
            event.username, event.password);
        authBloc.add(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.message);
      }
    }
    if (event is CreateUserPressed) {
      yield LoginLoading();

      try {
        final String token = await repo.createUserWithEmailAndPassword(
            event.username, event.password);
        authBloc.add(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.message);
      }
    }
    if(event is ResetPasswordPressed){
      yield LoginLoading();
      try {
        await repo.resetPassword(event.username);
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.message);
      }
    }
  }
}

//Login States

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}

// Login Events

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    this.username,
    this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}

class CreateUserPressed extends LoginEvent {
  final String username;
  final String password;

  const CreateUserPressed({
    this.username,
    this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'CreateUserPressed { username: $username, password: $password }';
}

class ResetPasswordPressed extends LoginEvent {
  final String username;
  const ResetPasswordPressed({this.username});
  @override
  List<Object> get props => [username];

  @override
  String toString() => 'ResetPasswordPressed { username: $username }';
}
