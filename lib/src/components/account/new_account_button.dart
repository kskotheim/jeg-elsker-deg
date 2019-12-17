import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';

class CreateNewAccountButton extends StatefulWidget {
  @override
  _CreateNewAccountButtonState createState() => _CreateNewAccountButtonState();
}

class _CreateNewAccountButtonState extends State<CreateNewAccountButton> {
  bool showTextField = false;
  TextEditingController newAccountNameField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (showTextField) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 120.0,
            child: TextField(
              controller: newAccountNameField,
              textAlign: TextAlign.center,
              maxLength: 30,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () => setState(() => showTextField = false),
              ),
              Container(
                width: 30.0,
              ),
              RaisedButton(
                child: Text('Create'),
                onPressed: () {
                  BlocProvider.of<AccountBloc>(context).add(
                    CreateGroup(groupName: newAccountNameField.text),
                  );
                  newAccountNameField.clear();
                  setState(() => showTextField = false);
                },
              ),
            ],
          )
        ],
      );
    } else {
      return RaisedButton(
        child: Text('Create Group'),
        onPressed: () => setState(() => showTextField = true),
      );
    }
  }
}
