import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/login/login_bloc.dart';
import 'package:my_love/src/util/button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authBloc: BlocProvider.of<AuthBloc>(context),
      ),
      child: LoginWidget(),
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  LoginBloc loginBloc;

  void login() => loginBloc.add(LoginButtonPressed(
      username: _usernameController.text, password: _passwordController.text));
  void resetPassword() =>
      loginBloc.add(ResetPasswordPressed(username: _usernameController.text));
  void createAccount() => loginBloc.add(CreateUserPressed(
      username: _usernameController.text, password: _passwordController.text));

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) => Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Email', textScaleFactor: 1.2,),
                      TextField(
                        controller: _usernameController,
                        autofocus: true,
                      ),
                    ],
                  ),
                  Container(height: 30.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Password', textScaleFactor: 1.2,),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                      ),
                    ],
                  ),
                  Container(height: 30.0),
                  state is! LoginLoading ?
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AccountButton(
                        text: 'Login',
                        onPressed: login,
                      ),
                      AccountButton(
                        text: 'CreateAccount',
                        onPressed: createAccount,
                      ),
                      AccountButton(
                        text: 'Reset Password',
                        onPressed: resetPassword,
                      ),
                    ],
                  ) : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
