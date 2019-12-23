import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final num fontSize;
  final String fontFamily;

  TextWidget(this.text, {this.fontSize = 12.0, this.fontFamily = 'Montserrat'});


  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSize, fontFamily: fontFamily),);
  }
}