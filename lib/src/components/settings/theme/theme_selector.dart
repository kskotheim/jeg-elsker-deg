
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/settings_page.dart';
import 'package:my_love/src/components/settings/theme/theme.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: Container(
            decoration: borderDecoration(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleText(
                    'Theme',
                    context),
              ],
            ),
          ),
          onTap: () => BlocProvider.of<ShowThemeSection>(context).toggle(),
        ),
        BlocBuilder<ShowThemeSection, bool>(
          builder: (context, showThemeSection) {
            return AnimatedSizeAndFade(
              vsync: this,
              fadeDuration: TRANSITION_DURATION,
              sizeDuration: TRANSITION_DURATION,
              child: _buildPage(context, showThemeSection),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPage(BuildContext context, bool showThemeSection) {
    if (!showThemeSection) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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