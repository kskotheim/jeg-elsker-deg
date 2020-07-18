import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/settings_page.dart';

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
            return CircularProgressIndicator(
              strokeWidth: 6.0,
            );
          }
          if (state is ShowGroupInfo) {
            return Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(height: 20.0),
                        ClayContainer(
                          color:
                              BlocProvider.of<ThemeBloc>(context).theme.bgColor,
                          child: SweetNothingWidget(),
                          borderRadius: 35.0,
                        ),
                        Container(height: 30.0),
                        ClayContainer(
                          depth: 30,
                          spread: 20.0,
                          color:
                              BlocProvider.of<ThemeBloc>(context).theme.bgColor,
                          curveType: CurveType.concave,
                          child: ImageWidget(),
                        ),
                        Container(
                          height: 50.0,
                        ),
                      ],
                    ),
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
    return Image(
      width: imageWidth,
      image: AssetImage(BlocProvider.of<GroupBloc>(context).todaysImage()),
    );
  }
}
