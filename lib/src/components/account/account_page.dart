import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/account/connect_to_group.dart';
import 'package:my_love/src/components/account/group_list/group_list.dart';
import 'package:my_love/src/components/account/new_account_button.dart';
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
          if (state is ShowRenameUserPage) {
            return RenameUserPage();
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
              'Welcome ${BlocProvider.of<AccountBloc>(context).currentUser.userName}!'),
          CreateNewAccountButton(),
          ConnectToGroupButton(),
          RaisedButton(
            child: Text('Log out'),
            onPressed: () =>
                BlocProvider.of<AuthBloc>(context).add(LoggedOut()),
          ),
          GroupsList(),
        ],
      ),
    );
  }
}

class RenameUserPage extends StatelessWidget {
  TextEditingController _username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Name:'),
          Container(
            width: 100.0,
            child: TextField(
              controller: _username,
              maxLength: 30,
            ),
          ),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () => BlocProvider.of<AccountBloc>(context)
                .add(RenameUser(userName: _username.text)),
          ),
        ],
      ),
    );
  }
}
