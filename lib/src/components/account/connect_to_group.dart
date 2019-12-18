import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';


class ConnectToGroupButton extends StatefulWidget {
  @override
  _ConnectToGroupButtonState createState() => _ConnectToGroupButtonState();
}

class _ConnectToGroupButtonState extends State<ConnectToGroupButton> {

  bool showTextField = false;
  bool fieldValid = false;
  TextEditingController passwordController = TextEditingController();

    @override
  Widget build(BuildContext context) {
    if (showTextField) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 120.0,
            child: TextField(
              controller: passwordController,
              textAlign: TextAlign.center,
              maxLength: 6,
              onChanged: validate,
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
                child: Text('Connect'),
                onPressed: fieldValid ? () {
                  BlocProvider.of<AccountBloc>(context).add(
                    AttemptConnection(password: passwordController.text),
                  );
                  passwordController.clear();
                  setState(() => showTextField = false);
                } : null,
              ),
            ],
          )
        ],
      );
    } else {
      return RaisedButton(
        child: Text('Connect to Group'),
        onPressed: () => setState(() => showTextField = true),
      );
    }
  }

  void validate(String text){
    setState(() => fieldValid = text.length == 6);
  }
}