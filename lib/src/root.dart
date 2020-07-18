import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_page.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/login/login_page.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/theme.dart';

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
        child: BlocBuilder<ThemeBloc, AppTheme>(
          builder: (context, theme) {
            return Scaffold(
              backgroundColor: theme.bgColor,
              body: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthStateAuthenticated) {
                    return AccountPage();
                  }
                  if (authState is AuthStateNotAuthenticated) {
                    return LoginPage();
                  }
                  if (authState is AuthStateUninitialized) {
                    return SplashScreen();
                  }
                  return LoadingScreen();
                },
              ),
            );
          }
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
        ],
      ),
    );
  }
}
