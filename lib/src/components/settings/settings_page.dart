import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager.dart';
import 'package:my_love/src/components/settings/policies/buttons.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/stats/stats_viewer.dart';
import 'package:my_love/src/components/settings/theme/theme_selector.dart';
import 'package:my_love/src/util/bool_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShowNothingsManager>(
          create: (context) => ShowNothingsManager(),
        ),
        BlocProvider<ShowThemeSection>(
          create: (context) => ShowThemeSection(),
        ),
        BlocProvider<ShowStatsSection>(
          create: (context) => ShowStatsSection(),
        ),
      ],
      child: Stack(
        children: [
          Center(
            child: ListView(
              children: [
                Container(
                  height: 80.0,
                ),
                NothingsManager(),
                Container(height: 30.0),
                ThemeSelector(),
                Container(
                  height: 30.0,
                ),
                StatsPage(),
                Container(height: 60.0),
                PolicyButtons(),
                Container(
                  height: 30.0,
                )
                // UpgradeToProButton(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ReturnToGroupButton(),
            ),
          ),
          LogoutButton(),
        ],
      ),
    );
  }
}

class ReturnToGroupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => BlocProvider.of<GroupBloc>(context).add(GoToGroupHome()),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: RaisedButton(
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text('Logout?'),
              children: <Widget>[
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context, false),
                )
              ],
            ),
          ).then(
            (result) {
              if (result) {
                BlocProvider.of<AuthBloc>(context).add(LoggedOut());
              }
            },
          ),
        ),
      ),
    );
  }
}

class UpgradeToProButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50.0,
        width: 200.0,
        child: ClayContainer(
          child: Center(child: Text('Upgrade \$5')),
          color: BlocProvider.of<ThemeBloc>(context).theme.bgColor,
        ),
      ),
    );
  }
}


Text titleText(String title, BuildContext context) => Text(
      title,
      style:
          TextStyle(color: BlocProvider.of<ThemeBloc>(context).theme.altColor),
      textScaleFactor: 1.5,
    );

BoxDecoration borderDecoration(BuildContext context) => BoxDecoration(
    border: Border(
        bottom: BorderSide(
            color: BlocProvider.of<ThemeBloc>(context).theme.altColor,
            width: 5.0)));


const Duration TRANSITION_DURATION = const Duration(milliseconds: 500);

// bool bloc for showing / hiding nothings manager

class ShowNothingsManager extends BoolBloc {}

// bool bloc for showing / hiding theme section

class ShowThemeSection extends BoolBloc {}

class ShowStatsSection extends BoolBloc {}
