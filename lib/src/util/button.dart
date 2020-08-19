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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(
            color: BlocProvider.of<ThemeBloc>(context).theme.altColor,
            width: 1.4),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: BlocProvider.of<ThemeBloc>(context).theme.altColor),
      ),
      onPressed: onPressed,
      color: BlocProvider.of<ThemeBloc>(context).theme.bgColor.withAlpha(230),
    );
  }
}
