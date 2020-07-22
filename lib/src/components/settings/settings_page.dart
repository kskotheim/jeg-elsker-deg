import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ListView(
            children: [
              Container(
                height: 80.0,
              ),
              NothingsManager(),
              UpgradeToProButton(),
              ThemeSelector(),
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
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: LogoutButton(),
          ),
        ),
      ],
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
    return RaisedButton(
      child: Text(
        'Logout',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.red,
      onPressed: () => BlocProvider.of<AuthBloc>(context).add(LoggedOut()),
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

class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
