import 'package:flutter/material.dart';
import 'package:my_love/src/root.dart';

void main() => runApp(MyLove());

class MyLove extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
