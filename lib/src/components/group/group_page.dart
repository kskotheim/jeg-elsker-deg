import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager.dart';

class GroupPage extends StatelessWidget {
  final String groupId;
  GroupPage({this.groupId}) : assert(groupId != null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupBloc>(
      create: (context) => GroupBloc(
          groupId: groupId,
          currentUserId:
              BlocProvider.of<AccountBloc>(context).currentUser.userId),
      child: Center(
        child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
          if (state is GroupStateLoading) {
            return CircularProgressIndicator(strokeWidth: 8.0,);
          }
          if (state is ShowGroupInfo) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SweetNothingWidget(),
                      Container(height: 30.0),
                      ImageWidget(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: PreferencesIconButton(),
                  ),
                ),
              ],
            );
          }
          if (state is ShowGroupPreferences) {
            return Stack(
              children: <Widget>[
                Center(
                  child: NothingsManager(),
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
        }),
      ),
    );
  }
}

class PreferencesIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: Colors.blueGrey,
      ),
      onPressed: () =>
          BlocProvider.of<GroupBloc>(context).add(PreferencesButtonPushed()),
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

class SweetNothingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Text(
          '${BlocProvider.of<GroupBloc>(context).todaysNothing()}',
          style: TextStyle(fontSize: 50.0, fontFamily: 'MaShanZheng'),
        ),
      ),
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

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const List<String> images = [
      'assets/img/backgrounds/amsterdam.jpg',
      'assets/img/backgrounds/dahlia.jpg',
      'assets/img/backgrounds/daisies.jpg',
      'assets/img/backgrounds/flowers.jpg',
      'assets/img/backgrounds/rijksmuseum.jpg',
      'assets/img/backgrounds/rose.jpg',
      'assets/img/backgrounds/wildflowers.jpg',
    ];

    return Image(
      height: 350.0,
      width: 225.0,
      image: AssetImage(images[Random().nextInt(images.length)]),
    );
  }
}
