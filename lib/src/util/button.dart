import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_love/src/components/settings/settings_bloc.dart';

class AccountButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  AccountButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
      color: BlocProvider.of<ThemeBloc>(context).theme.altColor,
    );
  }
}
