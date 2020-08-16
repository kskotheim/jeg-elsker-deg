import 'package:carousel_slider/carousel_slider.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/account/connect_to_group.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/group/group_page.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';
import 'package:my_love/src/components/settings/settings_page.dart';
import 'package:my_love/src/root.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountBloc>(
          create: (context) =>
              AccountBloc(userId: BlocProvider.of<AuthBloc>(context).token),
        ),
        BlocProvider<ShowThemeSection>(
          create: (context) => ShowThemeSection(),
        ),
      ],
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is ShowUserPage) {
            return UserPage();
          }
          if (state is ShowGroupPage) {
            return GroupPage(groupId: state.groupId);
          }
          if (state is AccountLoadingPage) {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SliderIntro(),
                ConnectToGroupButton(),
                PasswordWidget(),
                ThemeSelector(),
              ],
            ),
          ),
        ),
        LogoutButton(),
      ],
    );
  }
}

class SliderIntro extends StatefulWidget {
  @override
  _SliderIntroState createState() => _SliderIntroState();
}

class _SliderIntroState extends State<SliderIntro> {
  int _current = 0;
  List<String> itemList = [
    'Welcome!',
    'MyLove is an app for couples to share notes with each other each day.',
    'Once you form your group you can create a list of nice things to tell your love. Each day a random note will be shown to your partner. ',
    'You can create your own notes which can by public or private, or browse notes shared by others.',
    'This is an initial version. More features will be added if people use it, so please share with others and leave a review if you like it.',
    'For now, once you and your partner have both downloaded the app and created an account, connect to each other by entering the other\'s password.',
    'Only one of you needs to do this, and you will only need to do this once.',
    'Thank you for trying it and I hope you enjoy! <3',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            items: itemList.map((e) => CarouselText(e)).toList(),
            options: CarouselOptions(
                enableInfiniteScroll: false,
                onPageChanged: (index, _) => setState(() => _current = index)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: itemList.map((url) {
              int index = itemList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? BlocProvider.of<ThemeBloc>(context).theme.altColor
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class CarouselText extends StatelessWidget {
  final String text;
  CarouselText(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClayContainer(
        borderRadius: 35.0,
        color: BlocProvider.of<ThemeBloc>(context).theme.bgColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text(
        'Password: ${BlocProvider.of<AccountBloc>(context).currentUser.password}',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
