import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/group/group_bloc.dart';
import 'package:my_love/src/components/group/nothings/nothings_manager.dart';
import 'package:my_love/src/components/settings/policies/privacy.dart';
import 'package:my_love/src/components/settings/policies/terms.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/theme.dart';
import 'package:my_love/src/util/bool_bloc.dart';
import 'package:my_love/src/util/button.dart';

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
                Container(height: 60.0),
                PolicyButtons(),
                Container(height: 30.0,)
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

class PolicyButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AccountButton(
          text: 'Privacy Policy',
          onPressed: () => showDialog(
            context: context,
            child: SimpleDialog(
              title: Text('Privacy Policy'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(PRIVACY_STRING),
                ),
              ],
            ),
          ),
        ),
        AccountButton(
          text: 'Terms & Conditions',
          onPressed: () => showDialog(
            context: context,
            child: SimpleDialog(
              title: Text('Terms & Conditions'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(TERMS_STRING),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ThemeButton extends StatelessWidget {
  final AppTheme theme;

  ThemeButton(this.theme);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BlocProvider.of<ThemeBloc>(context).theme == theme
            ? BorderSide(color: theme.altColor)
            : BorderSide.none,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocProvider.of<ThemeBloc>(context).theme == theme
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                  child: ColoredBox(
                    color: theme.bgColor,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                ),
          Text(
            theme.name,
            style: TextStyle(color: theme.altColor),
          ),
        ],
      ),
      onPressed: () => BlocProvider.of<ThemeBloc>(context).add(SetTheme(theme)),
    );
  }
}

class ThemeSelector extends StatefulWidget {
  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowThemeSection, bool>(
      builder: (context, showThemeSection) {
        return AnimatedSizeAndFade(
          vsync: this,
          fadeDuration: TRANSITION_DURATION,
          sizeDuration: TRANSITION_DURATION,
          child: _buildPage(context, showThemeSection),
        );
      },
    );
  }

  Widget _buildPage(BuildContext context, bool showThemeSection) {
    if (!showThemeSection) {
      return InkWell(
        child: Container(
          decoration: borderDecoration(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleText(
                  'Theme - ${BlocProvider.of<ThemeBloc>(context).theme.name}',
                  context),
            ],
          ),
        ),
        onTap: () => BlocProvider.of<ShowThemeSection>(context).toggle(),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: Container(
            decoration: borderDecoration(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleText('Theme', context),
              ],
            ),
          ),
          onTap: () => BlocProvider.of<ShowThemeSection>(context).toggle(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ThemeButton(PURPLE_THEME),
            ThemeButton(BLUE_THEME),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ThemeButton(YELLOW_THEME),
            ThemeButton(GREEN_THEME),
          ],
        )
      ],
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
