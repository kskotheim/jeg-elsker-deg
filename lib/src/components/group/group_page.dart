import 'package:auto_size_text/auto_size_text.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/settings_page.dart';
import 'package:my_love/src/util/wave_animation.dart';

class GroupPage extends StatelessWidget {
  final String groupId;
  GroupPage({this.groupId}) : assert(groupId != null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupBloc>(
      create: (context) => GroupBloc(
        groupId: groupId,
        currentUserId: BlocProvider.of<AccountBloc>(context).currentUser.userId,
        waveBloc: BlocProvider.of<WaveBloc>(context),
      ),
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: _buildPage(context, state),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, GroupState state) {
    if (state is GroupStateLoading) {
      return CircularProgressIndicator(
        strokeWidth: 6.0,
      );
    }
    if (state is ShowGroupInfo) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(),
                SweetNothingWidget(),
                PressableDough(
                  child: ImageWidget(),
                ),
                Container(),
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
      return Center(
        child: SettingsPage(),
      );
    }
  }
}

class PreferencesIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: BlocProvider.of<ThemeBloc>(context).theme.altColor,
      ),
      onPressed: () =>
          BlocProvider.of<GroupBloc>(context).add(PreferencesButtonPushed()),
    );
  }
}

class SweetNothingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * .2 +
        ((BlocProvider.of<GroupBloc>(context)
                    .todaysNothing()
                    .length
                    .toDouble() /
                160) *
            MediaQuery.of(context).size.height *
            .1);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: PressableDough(
        child: ClayContainer(
          color: BlocProvider.of<ThemeBloc>(context).theme.bgColor,
          borderRadius: 35.0,
          child: Container(
            height: containerHeight,
            width: MediaQuery.of(context).size.width * .7,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: AutoSizeText(
                  '${BlocProvider.of<GroupBloc>(context).todaysNothing()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'MaShanZheng',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * .5;
    if (imageWidth > 500.0) {
      imageWidth = 500.0;
    }
    if (imageWidth < 225.0) {
      imageWidth = 225.0;
    }
    return ClayContainer(
      color: BlocProvider.of<ThemeBloc>(context).theme.bgColor,
      spread: 30.0,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20.0),
      //   boxShadow: [
      //     CustomBoxShadow(
      //         color: Colors.black54,
      //         offset: Offset.zero,
      //         blurRadius: 30.0,
      //         blurStyle: BlurStyle.outer),
      //   ],
      // ),
      child: Image(
        width: imageWidth,
        image: AssetImage(BlocProvider.of<GroupBloc>(context).todaysImage()),
      ),
    );
  }
}
