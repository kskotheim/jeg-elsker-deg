import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/account/connect_to_group.dart';
import 'package:my_love/src/components/auth/auth_bloc.dart';
import 'package:my_love/src/components/group/group_page.dart';
import 'package:my_love/src/root.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) =>
          AccountBloc(userId: BlocProvider.of<AuthBloc>(context).token),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
              'Welcome!'),
          ConnectToGroupButton(),
          PasswordWidget(),
          RaisedButton(
            child: Text('Log out'),
            onPressed: () =>
                BlocProvider.of<AuthBloc>(context).add(LoggedOut()),
          ),
        ],
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