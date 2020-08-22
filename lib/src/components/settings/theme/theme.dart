import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final Color bgColor;
  final Color altColor;
  const AppTheme(this.bgColor, this.altColor,this.name);
  @override
  String toString() => name;
}

const AppTheme PURPLE_THEME = const AppTheme(Color.fromRGBO(218, 194, 242, 1.0), Color.fromRGBO(26, 106, 26, 1.0), 'Lavender');

const AppTheme BLUE_THEME = const AppTheme(Color.fromRGBO(136, 228, 233, 1.0), Color.fromRGBO(25, 61, 77, 1.0), 'Lagoon');

const AppTheme YELLOW_THEME = const AppTheme(Color.fromRGBO(251, 247, 191, 1.0), Color.fromRGBO(124, 27, 75, 1.0), 'Sunset');

const AppTheme GREEN_THEME = const AppTheme(Color.fromRGBO(92, 172, 16, 1.0), Color.fromRGBO(72, 60, 31, 1.0), 'Rainforest');