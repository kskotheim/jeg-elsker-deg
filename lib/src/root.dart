
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_page.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/login/login_page.dart';

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthStateAuthenticated) {
              return AccountPage();
            }
            if (state is AuthStateNotAuthenticated) {
              return LoginPage();
            }
            if (state is AuthStateUninitialized) {
              return SplashScreen();
            }
            return LoadingScreen();
          },
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          Text('Loading...'),
        ],
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LinearProgressIndicator(),
          Text('Splash Screen!'),
        ],
      ),
    );
  }
}

