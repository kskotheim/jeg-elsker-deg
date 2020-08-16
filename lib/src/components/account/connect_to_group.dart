import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/account/account_bloc.dart';
import 'package:my_love/src/components/settings/settings_page.dart';
import 'package:my_love/src/util/button.dart';

class ConnectToGroupButton extends StatefulWidget {
  @override
  _ConnectToGroupButtonState createState() => _ConnectToGroupButtonState();
}

class _ConnectToGroupButtonState extends State<ConnectToGroupButton>
    with TickerProviderStateMixin {
  bool showTextField = false;
  bool fieldValid = false;
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      fadeDuration: TRANSITION_DURATION,
      sizeDuration: TRANSITION_DURATION,
      vsync: this,
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
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
              AccountButton(
                text: 'Cancel',
                onPressed: () => setState(() => showTextField = false),
              ),
              Container(
                width: 30.0,
              ),
              AccountButton(
                text: 'Connect',
                onPressed: fieldValid
                    ? () {
                        BlocProvider.of<AccountBloc>(context).add(
                          AttemptConnection(password: passwordController.text),
                        );
                        passwordController.clear();
                        setState(() => showTextField = false);
                      }
                    : null,
              ),
            ],
          )
        ],
      );
    } else {
      return AccountButton(
        text:'Connect to User',
        onPressed: () => setState(() => showTextField = true),
      );
    }
  }

  void validate(String text) {
    setState(() => fieldValid = text.length == 6);
  }
}
