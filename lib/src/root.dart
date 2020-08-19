import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_page.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/login/login_page.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/theme.dart';
import 'package:my_love/src/util/wave_animation.dart';

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
        child: BlocBuilder<ThemeBloc, AppTheme>(builder: (context, theme) {
          return Theme(
            data: ThemeData(
              primaryColor: theme.altColor,
              accentColor: theme.bgColor,
              cursorColor: theme.altColor,
            ),
            child: Scaffold(
              backgroundColor: theme.bgColor,
              body: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  return AnimatedWave(
                    height: MediaQuery.of(context).size.height * .1,
                    speed: .2,
                    alpha: 60,
                    reverse: true,
                    child: AnimatedWave(
                      height: MediaQuery.of(context).size.height * .15,
                      speed: .4,
                      child: AnimatedWave(
                        height: MediaQuery.of(context).size.height * .25,
                        speed: .25,
                        top: false,
                        alpha: 20,
                        child: AnimatedWave(
                          height: MediaQuery.of(context).size.height * .12,
                          reverse: true,
                          top: false,
                          speed: .4,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: _buildPage(authState),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPage(AuthState authState) {
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
