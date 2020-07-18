import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final Color bgColor;
  final Color altColor;
  final BoxShape buttonShape;
  const AppTheme(this.bgColor, this.altColor, this.buttonShape, this.name);
  @override
  String toString() => name;
}

const AppTheme PURPLE_THEME = AppTheme(Color.fromRGBO(204, 153, 255, 1.0), Color.fromRGBO(153, 0, 153, 1.0), BoxShape.circle, 'Purple');

const AppTheme BLUE_THEME = AppTheme(Color.fromRGBO(102, 204, 255, 1.0), Color.fromRGBO(51, 102, 204, 1.0), BoxShape.rectangle, 'Bue');